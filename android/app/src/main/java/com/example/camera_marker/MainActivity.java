
package uit.kltn.cttt2015.camera_marker;

import java.util.*;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;

import androidx.annotation.NonNull;

import java.io.IOException;
import java.util.List;
import android.content.Context;
import android.content.ContextWrapper;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import org.opencv.imgproc.Imgproc;

import android.util.Log;

import org.opencv.android.Utils;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.android.OpenCVLoader;
import java.io.File;
import java.io.FileOutputStream;
import org.opencv.core.Scalar;
import org.opencv.core.MatOfPoint;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Rect;
import org.opencv.core.Size;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Calendar;
import java.util.Date;
import java.time.ZonedDateTime;

import tomerblecher.yuvtransform.YuvConverter;
import org.opencv.photo.Photo;

public class MainActivity extends FlutterActivity {
    // Set a name for the method chanel.
    // This name is a key for the Flutter MethodChannel and needs to be equal to the
    // name configured at the dart part
    private static final String CHANNEL = "tomer.blecher.yuv_transform/yuv";
    private Mat mRgba = null;

    private Mat bitmapToMat(Bitmap bmp) {
        Mat mat = new Mat();
        Bitmap bmp32 = bmp.copy(Bitmap.Config.ARGB_8888, true);
        Utils.bitmapToMat(bmp32, mat);
        return mat;
    }

    private Bitmap matToBitmap(Mat m) {
        Bitmap myBitmap = null;
        myBitmap = Bitmap.createBitmap(m.cols(), m.rows(), Bitmap.Config.ARGB_8888);
        Utils.matToBitmap(m, myBitmap);
        return myBitmap;
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        System.out.println("JAVA REGISTERED ");
        OpenCVLoader.initDebug();
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    //
                    switch (call.method) {
                    case "yuv_transform": {

                        List<byte[]> bytesList = call.argument("platforms");
                        int[] strides = call.argument("strides");
                        int templateId = call.argument("template_id");
                        int width = call.argument("width");
                        int height = call.argument("height");
                        String form = call.argument("form");
                        if(form == null) {
                            form = "60";
                        }
                        String type = call.argument("type");

                        // example code
                        byte[] data = YuvConverter.NV21toJPEG(YuvConverter.YUVtoNV21(bytesList, strides, width, height),
                                width, height, 100);

                        Bitmap bitmapRaw = BitmapFactory.decodeByteArray(data, 0, data.length);
                        Matrix matrix = new Matrix();
                        matrix.postRotate(90);
                        Bitmap finalbitmap = Bitmap.createBitmap(bitmapRaw, 0, 0, bitmapRaw.getWidth(),
                                bitmapRaw.getHeight(), matrix, true);

                        mRgba = bitmapToMat(finalbitmap);
                        int max_height = mRgba.rows();
                        int max_width = mRgba.cols();
                        Mat mRgbaCopy = mRgba.clone();

                        int numberRect = 0;
                        Scalar s = new Scalar(255, 0, 0);
                        if (Objects.equals(type, new String("test"))) {
                            // compare with request data to get right answer for examcode
                            ArrayList<HashMap> answerReq = call.argument("answer");

                            // array store right
                            String examCodeReq = "";
                            JSONArray stdAnswer = new JSONArray();

                            try {
                                for (int i = 0; i < answerReq.size(); i++) {
                                    examCodeReq = (String) answerReq.get(i).get("examCode");

                                    ArrayList<HashMap> value = (ArrayList) answerReq.get(i).get("value");
                                    for (int j = 0; j < value.size(); j++) {
                                        JSONObject stdAnswerJson = new JSONObject();
                                        String temp = (String) value.get(j).get("valueString");
                                        stdAnswerJson.put("valueString", temp);
                                        stdAnswer.put(stdAnswerJson);
                                    }
                                    break;

                                }
                            } catch (Exception e) {
                                Log.e("", e.getMessage());
                            }

                            // save file
                            Bitmap myBitmap = null;
                            // Getting the current date
                            Date date = new Date();
                            // This method returns the time in millis
                            long timeMilli = date.getTime();

                            myBitmap = Bitmap.createBitmap(mRgbaCopy.cols(), mRgbaCopy.rows(), Bitmap.Config.ARGB_8888);
                            Utils.matToBitmap(mRgbaCopy, myBitmap);
                            String studentCode = "1234";
                            String path = saveToInternalStorage(myBitmap, studentCode + "_" + timeMilli + ".png");

                            JSONObject feedback = new JSONObject();
                            try {
                                feedback.put("answer", true);
                                feedback.put("width", max_width);
                                feedback.put("height", max_height);
                                feedback.put("examCode", examCodeReq);
                                feedback.put("studentCode", studentCode);
                                feedback.put("image", path);
                                feedback.put("value", stdAnswer);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            mRgba.release();
                            mRgbaCopy.release(); //
                            result.success(feedback.toString());
                            return;
                        }
                        int[][] pointsValue = new int[][] { { 0, 0, 100, 100, 1 },
                                { max_width - 100, 0, max_width, 100, 2 }, { 0, max_height - 100, 100, max_height, 3 },
                                { max_width - 100, max_height - 100, max_width, max_height, 4 }, };
                        int numPoint = 0;

                        Point ptr = null;
                        Point ptl = null;
                        Point pbl = null;
                        Point pbr = null;
                        Scalar ss = new Scalar(255, 0, 0, 255);

                        for (int i = 0; i < 4; i++) {
                            Point p1 = new Point(pointsValue[i][0], pointsValue[i][1]);
                            Point p2 = new Point(pointsValue[i][2], pointsValue[i][3]);

                            // cat ra ô vuông để sử lý
                            Rect rectCrop = new Rect(p1, p2);
                            Mat image_roi = new Mat(mRgba, rectCrop);
                            Mat hierarchy = new Mat();
                            Mat tmp = new Mat();
                            List<MatOfPoint> contours = new ArrayList<MatOfPoint>();

                            Imgproc.Canny(image_roi, tmp, 80, 100);
                            Imgproc.findContours(tmp, contours, hierarchy, Imgproc.RETR_TREE,
                                    Imgproc.CHAIN_APPROX_SIMPLE);

                            innerLoop: for (MatOfPoint c : contours) {
                                double area = Imgproc.contourArea(c);
                                if (area > 150 && area < 2000) {
                                    MatOfPoint2f c2f = new MatOfPoint2f(c.toArray());
                                    double peri = Imgproc.arcLength(c2f, true);
                                    MatOfPoint2f approx = new MatOfPoint2f();
                                    Imgproc.approxPolyDP(c2f, approx, 0.02 * peri, true);

                                    Point[] points = approx.toArray();

                                    // select biggest 4 angles polygon
                                    if (points.length == 4) {

                                        // rectangle = x,y,w,h
                                        Rect rectangle = Imgproc.boundingRect(c);
                                        int x = (int) rectangle.tl().x;
                                        int y = (int) rectangle.tl().y;
                                        if (pointsValue[i][4] == 1) {
                                            pointsValue[i][0] = x;
                                            pointsValue[i][1] = y;
                                            pointsValue[i][2] = rectangle.width;
                                            pointsValue[i][3] = rectangle.height;
                                            ptl = new Point(rectangle.tl().x + rectangle.width, rectangle.tl().y);
                                        }
                                        if (pointsValue[i][4] == 2) {
                                            pointsValue[i][0] = pointsValue[i][0] + x;
                                            pointsValue[i][1] = pointsValue[i][1] + y;
                                            pointsValue[i][2] = rectangle.width;
                                            pointsValue[i][3] = rectangle.height;
                                            ptr = new Point(max_width - 100 + rectangle.tl().x, rectangle.tl().y);
                                        }
                                        if (pointsValue[i][4] == 3) {
                                            pointsValue[i][0] = x;
                                            pointsValue[i][1] = pointsValue[i][1] + y;
                                            pointsValue[i][2] = rectangle.width;
                                            pointsValue[i][3] = rectangle.height;
                                            pbl = new Point(rectangle.tl().x + rectangle.width,
                                                    max_height - 100 + rectangle.tl().y);
                                        }
                                        if (pointsValue[i][4] == 4) {
                                            pointsValue[i][0] = pointsValue[i][0] + x;
                                            pointsValue[i][1] = pointsValue[i][1] + y;
                                            pointsValue[i][2] = rectangle.width;
                                            pointsValue[i][3] = rectangle.height;
                                            pbr = new Point(max_width - 100 + rectangle.tl().x,
                                                    max_height - 100 + rectangle.tl().y);
                                        }
                                        numberRect = numberRect + 1;
                                        MatOfPoint point = new MatOfPoint(approx.toArray());
                                        Rect rect = Imgproc.boundingRect(point);
                                        Imgproc.rectangle(image_roi, new Point(rect.x, rect.y),
                                                new Point(rect.x + rect.width, rect.y + rect.height),
                                                new Scalar(255, 0, 0, 255), 3);
                                        break innerLoop;
                                    }
                                }
                            }
                        }
                        boolean isAnswer = false;
                        JSONObject feedback = new JSONObject();

                        try {
                            feedback.put("width", max_width);
                            feedback.put("height", max_height);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                        int correctAnwers = 0;
                        String path = null;
                        String error = "";
                        String studentCode = "";
                        String examCode = "";
                        int non0;
                        JSONArray stdAnswer = new JSONArray();

                        if (numberRect == 4) {
                            isAnswer = true;

                            Size size = new Size(max_width, max_height);
                            MatOfPoint2f dst = new MatOfPoint2f(new Point(0, 0), new Point(size.width, 0),
                                    new Point(0, size.height), new Point(size.width, size.height));
                            MatOfPoint2f src = new MatOfPoint2f(ptl, ptr, pbl, pbr);

                            Mat warpMat = Imgproc.getPerspectiveTransform(src, dst);
                            Imgproc.warpPerspective(mRgba, mRgba, warpMat, size);

                            // Photo.detailEnhance(mRgba, mRgba);
                            Mat mRgbaRaw = mRgba.clone();

                            Imgproc.resize(mRgba, mRgba, new Size(1080, 2100));

                            mRgbaCopy = mRgba.clone();

                            Imgproc.cvtColor(mRgba, mRgba, Imgproc.COLOR_BGR2GRAY);
                            int width_c = 1080;
                            int height_c = 2100;

                            Imgproc.adaptiveThreshold(mRgba, mRgba, 255, Imgproc.ADAPTIVE_THRESH_MEAN_C,
                                    Imgproc.THRESH_BINARY, 121, 2);
                            if (templateId == 1){
                                // config width and height of box choice
                                int box_width = 41;
                                int box_height = 60;

                                // start get student id
                                Point p1 = new Point();
                                Point p2 = new Point();
                                for (int i = 0; i < 6; i++) {
                                    int count = 0;
                                    for (int j = 0; j < 10; j++) {
                                        p1.x = i * box_width + 30 + 14;
                                        p1.y = j * box_height + 770 + 14;
                                        p2.x = p1.x + box_width - 14 - 14;
                                        p2.y = p1.y + box_height - 14 - 14;

                                        //
                                        Rect rectCrop = new Rect(p1, p2);
                                        Mat image_roi = new Mat(mRgba, rectCrop);
                                        non0 = Core.countNonZero(image_roi);
                                        if (non0 < 50) {
                                            count++;
                                            Imgproc.rectangle(mRgbaCopy, p1, p2, s, 3);
                                            studentCode = studentCode + Integer.toString(j);
                                        }
                                        image_roi.release();

                                    }
                                    if (count != 1) {
                                        error = "stuId invalid";
                                    }
                                }

                                // get exam code
                                for (int i = 0; i < 3; i++) {
                                    int count = 0;
                                    for (int j = 0; j < 10; j++) {
                                        p1.x = i * box_width + 320 + 14;
                                        p1.y = j * box_height + 770 + 14;
                                        p2.x = p1.x + box_width - 14 - 14;
                                        p2.y = p1.y + box_height - 14 - 14;
                                        Rect rectCrop = new Rect(p1, p2);
                                        Mat image_roi = new Mat(mRgba, rectCrop);
                                        non0 = Core.countNonZero(image_roi);
                                        if (non0 < 50) {
                                            count = count + 1;
                                            Imgproc.rectangle(mRgbaCopy, p1, p2, s, 3);
                                            examCode = examCode + Integer.toString(j);
                                        }
                                        image_roi.release();
                                    }
                                    if (count != 1) {
                                        error = "Exam code invalid";
                                    }
                                }
                                // compare with request data to get right answer for examcode
                                ArrayList<HashMap> answerReq = call.argument("answer");

                                // array store right
                                ArrayList AnswerTemp = new ArrayList();
                                String examCodeReq = "";
                                try {
                                    for (int i = 0; i < answerReq.size(); i++) {
                                        examCodeReq = (String) answerReq.get(i).get("examCode");
                                        if (Objects.equals(examCodeReq, new String(examCode))) {
                                            Log.d("=============", "get answer");
                                            ArrayList<HashMap> value = (ArrayList) answerReq.get(i).get("value");
                                            for (int j = 0; j < value.size(); j++) {
                                                String temp = (String) value.get(j).get("valueString");
                                                AnswerTemp.add(temp);
                                            }
                                            break;
                                        }

                                    }
                                } catch (Exception e) {
                                    Log.e("", e.getMessage());
                                }

                                // get answer
                                Scalar wrongColor = new Scalar(255.0, 0.0, 0.0, 255.0);
                                Scalar correctColor = new Scalar(0.0, 255.0, 0.0, 255.0);
                                int[][] listBox = new int[][] { { 567, 770 }, { 811, 770 }, { 72, 1430 }, { 319, 1430 },
                                        { 565, 1430 }, { 814, 1430 }, };

                                boxLoop: for (int i = 0; i < listBox.length; i++) {
                                    for (int row = 0; row < 10; row++) {
                                        int quesPoint = 0;
                                        String stdAnswerString = "";
                                        if (Objects.equals(type, new String("result"))
                                                && (row + i * 10) > AnswerTemp.size() - 1) {
                                            break boxLoop;
                                        }
                                        answerCol: for (int col = 0; col < 5; col++) {
                                            p1.x = col * box_width + listBox[i][0] + 14;
                                            p1.y = row * box_height + listBox[i][1] + 14;
                                            p2.x = p1.x + box_width - 14 - 14;
                                            p2.y = p1.y + box_height - 14 - 14;
                                            Rect rectCrop = new Rect(p1, p2);

                                            Mat image_roi = new Mat(mRgba, rectCrop);
                                            non0 = Core.countNonZero(image_roi);
                                            image_roi.release();
                                            String current_answer = numberToAnswer(col);
                                            if (Objects.equals(type, new String("result"))) {
                                                if (Objects.equals(AnswerTemp.get(row + i * 10),
                                                        new String(current_answer))) {
                                                    Imgproc.rectangle(mRgbaCopy, p1, p2, correctColor, 5);
                                                    if (non0 < 200) {
                                                        stdAnswerString += current_answer;
                                                        quesPoint = quesPoint + 1;
                                                    }
                                                } else if (non0 < 200) {
                                                    quesPoint = quesPoint - 1;
                                                    Imgproc.rectangle(mRgbaCopy, p1, p2, wrongColor, 5);
                                                    stdAnswerString += current_answer;
                                                }
                                                if (quesPoint > 0) {
                                                    correctAnwers += 1;
                                                }
                                            } else {
                                                if (non0 < 200) {
                                                    Imgproc.rectangle(mRgbaCopy, p1, p2, wrongColor, 5);
                                                    stdAnswerString += current_answer;
                                                }
                                            }

                                        }

                                        JSONObject stdAnswerJson = new JSONObject();
                                        try {
                                            stdAnswerJson.put("valueString", stdAnswerString);
                                            stdAnswer.put(stdAnswerJson);
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }
                                    }

                                }
                                if (Objects.equals(type, new String("result"))) {
                                    Imgproc.putText(mRgbaCopy, "studentCode: " + studentCode, new Point(611, 370),
                                            Core.FONT_HERSHEY_COMPLEX, 1, correctColor, 3);
                                    Imgproc.putText(mRgbaCopy, "examCode: " + examCode, new Point(611, 270),
                                            Core.FONT_HERSHEY_COMPLEX, 1, correctColor, 3);
                                    // Imgproc.putText(mRgbaCopy, correctAnwers + "/" + AnswerTemp.size(), new
                                    // Point(611, 570),
                                    // Core.FONT_HERSHEY_COMPLEX, 1, correctColor, 3);
                                    if (error.length() > 0) {
                                        Imgproc.putText(mRgbaCopy, error, new Point(611, 670),
                                                Core.FONT_HERSHEY_COMPLEX, 1, correctColor, 3);
                                    }

                                }
                                Imgproc.resize(mRgbaCopy, mRgbaCopy, new Size(480, 640));
                                // save file
                                Bitmap myBitmap = null;
                                // Getting the current date
                                Date date = new Date();
                                // This method returns the time in millis
                                long timeMilli = date.getTime();

                                myBitmap = Bitmap.createBitmap(mRgba.cols(), mRgba.rows(), Bitmap.Config.ARGB_8888);
                                Utils.matToBitmap(mRgba, myBitmap);
                                path = saveToInternalStorage(myBitmap, "resultT.png");

                                myBitmap = Bitmap.createBitmap(mRgbaRaw.cols(), mRgbaRaw.rows(),
                                        Bitmap.Config.ARGB_8888);
                                Utils.matToBitmap(mRgbaRaw, myBitmap);
                                path = saveToInternalStorage(myBitmap, "mRgbaRaw.png");

                                myBitmap = Bitmap.createBitmap(mRgbaCopy.cols(), mRgbaCopy.rows(),
                                        Bitmap.Config.ARGB_8888);
                                Utils.matToBitmap(mRgbaCopy, myBitmap);
                                path = saveToInternalStorage(myBitmap, studentCode + "_" + timeMilli + ".png");
                            }
                            if (templateId == 2){
                                // config width and height of box choice
                                int box_width = 36;
                                int box_height = 52;

                                // start get student id
                                Point p1 = new Point();
                                Point p2 = new Point();
                                for (int i = 0; i < 6; i++) {
                                    int count = 0;
                                    for (int j = 0; j < 10; j++) {
                                        p1.x = i * box_width + 90 + 10;
                                        p1.y = j * box_height + 360 + 10;
                                        p2.x = p1.x + box_width - 10 - 10;
                                        p2.y = p1.y + box_height - 10 - 10;

                                        //
                                        Rect rectCrop = new Rect(p1, p2);
                                        Mat image_roi = new Mat(mRgba, rectCrop);
                                        non0 = Core.countNonZero(image_roi);
//                                        Imgproc.rectangle(mRgbaCopy, p1, p2, s, 3);
                                        if (non0 < 200) {
                                            count++;
                                            Imgproc.rectangle(mRgbaCopy, p1, p2, s, 3);
                                            studentCode = studentCode + Integer.toString(j);
                                        }
                                        image_roi.release();

                                    }
                                    if (count != 1) {
                                        error = "stuId invalid";
                                    }
                                }

                                // get exam code
                                for (int i = 0; i < 3; i++) {
                                    int count = 0;
                                    for (int j = 0; j < 10; j++) {
                                        p1.x = i * box_width + 345 + 10;
                                        p1.y = j * box_height + 360 + 10;
                                        p2.x = p1.x + box_width - 10 - 10;
                                        p2.y = p1.y + box_height - 10 - 10;
                                        Rect rectCrop = new Rect(p1, p2);
                                        Mat image_roi = new Mat(mRgba, rectCrop);
                                        non0 = Core.countNonZero(image_roi);
                                        if (non0 < 200) {
                                            count = count + 1;
                                            Imgproc.rectangle(mRgbaCopy, p1, p2, s, 3);
                                            examCode = examCode + Integer.toString(j);
                                        }
                                        image_roi.release();
                                    }
                                    if (count != 1) {
                                        error = "Exam code invalid";
                                    }
                                }
                                // compare with request data to get right answer for examcode
                                ArrayList<HashMap> answerReq = call.argument("answer");

                                // array store right
                                ArrayList AnswerTemp = new ArrayList();
                                String examCodeReq = "";
                                try {
                                    for (int i = 0; i < answerReq.size(); i++) {
                                        examCodeReq = (String) answerReq.get(i).get("examCode");
                                        if (Objects.equals(examCodeReq, new String(examCode))) {
                                            Log.d("=============", "get answer");
                                            ArrayList<HashMap> value = (ArrayList) answerReq.get(i).get("value");
                                            for (int j = 0; j < value.size(); j++) {
                                                String temp = (String) value.get(j).get("valueString");
                                                AnswerTemp.add(temp);
                                            }
                                            break;
                                        }

                                    }
                                } catch (Exception e) {
                                    Log.e("", e.getMessage());
                                }

                                // get answer
                                Scalar wrongColor = new Scalar(255.0, 0.0, 0.0, 255.0);
                                Scalar correctColor = new Scalar(0.0, 255.0, 0.0, 255.0);
                                int[][] listBox = new int[][] { { 560, 365 }, { 775, 365 }, { 125, 935 }, { 345, 935 },
                                        { 560, 935 }, { 775, 935 }, { 125, 1510 }, { 345, 1510 }, { 560, 1510 }, { 775, 1510 }, };

                                boxLoop: for (int i = 0; i < listBox.length; i++) {
                                    for (int row = 0; row < 10; row++) {
                                        int quesPoint = 0;
                                        String stdAnswerString = "";
                                        if (Objects.equals(type, new String("result"))
                                                && (row + i * 10) > AnswerTemp.size() - 1) {
                                            break boxLoop;
                                        }
                                        answerCol: for (int col = 0; col < 5; col++) {
                                            p1.x = col * box_width + listBox[i][0] + 10;
                                            p1.y = row * box_height + listBox[i][1] + 10;
                                            p2.x = p1.x + box_width - 10 - 10;
                                            p2.y = p1.y + box_height - 10 - 10;
                                            Rect rectCrop = new Rect(p1, p2);

                                            Mat image_roi = new Mat(mRgba, rectCrop);
                                            non0 = Core.countNonZero(image_roi);
                                            image_roi.release();
                                            String current_answer = numberToAnswer(col);
//                                            Imgproc.rectangle(mRgbaCopy, p1, p2, wrongColor, 5);

                                            if (Objects.equals(type, new String("result"))) {
                                                if (Objects.equals(AnswerTemp.get(row + i * 10),
                                                        new String(current_answer))) {
                                                    Imgproc.rectangle(mRgbaCopy, p1, p2, correctColor, 5);
                                                    if (non0 < 200) {
                                                        stdAnswerString += current_answer;
                                                        quesPoint = quesPoint + 1;
                                                    }
                                                } else if (non0 < 200) {
                                                    quesPoint = quesPoint - 1;
                                                    Imgproc.rectangle(mRgbaCopy, p1, p2, wrongColor, 5);
                                                    stdAnswerString += current_answer;
                                                }
                                                if (quesPoint > 0) {
                                                    correctAnwers += 1;
                                                }
                                            } else {
                                                if (non0 < 150) {
                                                    Imgproc.rectangle(mRgbaCopy, p1, p2, wrongColor, 5);
                                                    stdAnswerString += current_answer;
                                                }
                                            }

                                        }

                                        JSONObject stdAnswerJson = new JSONObject();
                                        try {
                                            stdAnswerJson.put("valueString", stdAnswerString);
                                            stdAnswer.put(stdAnswerJson);
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }
                                    }

                                }
                                if (Objects.equals(type, new String("result"))) {
                                    Imgproc.putText(mRgbaCopy, "studentCode: " + studentCode, new Point(611, 370),
                                            Core.FONT_HERSHEY_COMPLEX, 1, correctColor, 3);
                                    Imgproc.putText(mRgbaCopy, "examCode: " + examCode, new Point(611, 270),
                                            Core.FONT_HERSHEY_COMPLEX, 1, correctColor, 3);
                                    // Imgproc.putText(mRgbaCopy, correctAnwers + "/" + AnswerTemp.size(), new
                                    // Point(611, 570),
                                    // Core.FONT_HERSHEY_COMPLEX, 1, correctColor, 3);
                                    if (error.length() > 0) {
                                        Imgproc.putText(mRgbaCopy, error, new Point(611, 670),
                                                Core.FONT_HERSHEY_COMPLEX, 1, correctColor, 3);
                                    }

                                }
                                Imgproc.resize(mRgbaCopy, mRgbaCopy, new Size(480, 640));
                                // save file
                                Bitmap myBitmap = null;
                                // Getting the current date
                                Date date = new Date();
                                // This method returns the time in millis
                                long timeMilli = date.getTime();

                                myBitmap = Bitmap.createBitmap(mRgba.cols(), mRgba.rows(), Bitmap.Config.ARGB_8888);
                                Utils.matToBitmap(mRgba, myBitmap);
                                path = saveToInternalStorage(myBitmap, "resultT.png");

                                myBitmap = Bitmap.createBitmap(mRgbaRaw.cols(), mRgbaRaw.rows(),
                                        Bitmap.Config.ARGB_8888);
                                Utils.matToBitmap(mRgbaRaw, myBitmap);
                                path = saveToInternalStorage(myBitmap, "mRgbaRaw.png");

                                myBitmap = Bitmap.createBitmap(mRgbaCopy.cols(), mRgbaCopy.rows(),
                                        Bitmap.Config.ARGB_8888);
                                Utils.matToBitmap(mRgbaCopy, myBitmap);
                                path = saveToInternalStorage(myBitmap, studentCode + "_" + timeMilli + ".png");
                            }
                            try {
                                feedback.put("answer", isAnswer);
                                feedback.put("examCode", examCode);
                                feedback.put("studentCode", studentCode);
                                feedback.put("image", path);
                                feedback.put("error", error);
                                feedback.put("e1rror", form == "100");
                                feedback.put("value", stdAnswer);

                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                            mRgbaCopy.release();
                        }
                        try {
                            feedback.put("points", new JSONArray(pointsValue));

                        } catch (JSONException e) {
                            e.printStackTrace();
                        }

                        mRgba.release();
                        mRgbaCopy.release(); //
                        result.success(feedback.toString());

                    }
                    }
                });

    }

    private String saveToInternalStorage(Bitmap bitmapImage, String path) {
        ContextWrapper cw = new ContextWrapper(getApplicationContext());
        // path to /data/data/yourapp/app_data/imageDir
        File directory = cw.getDir("imageDir", Context.MODE_PRIVATE);
        // Create imageDir
        File mypath = new File(directory, path);

        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(mypath);
            // Use the compress method on the BitMap object to write image to the
            // OutputStream
            bitmapImage.compress(Bitmap.CompressFormat.PNG, 100, fos);
            // Log.i(TAG, "saveToInternalStorage: Flia" + mypath);
        } catch (Exception e) {
            // Log.i(TAG, "saveToInternalStorage: Flia" + e);
            e.printStackTrace();
        } finally {
            try {
                fos.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return directory.getAbsolutePath() + "/" + path;
    }

    private String numberToAnswer(int number) {
        if (number == 0) {
            return "A";
        }
        if (number == 1) {
            return "B";
        }
        if (number == 2) {
            return "C";
        }
        if (number == 3) {
            return "D";
        }
        return "E";
    }

}