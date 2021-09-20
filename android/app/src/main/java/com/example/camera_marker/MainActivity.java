package uit.kltn.cttt2015.camera_marker;

import java.io.*;
import java.util.*;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
import android.content.Context;
import android.content.ContextWrapper;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import org.opencv.imgproc.Imgproc;
import android.graphics.BitmapFactory;
import org.opencv.android.Utils;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.android.OpenCVLoader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import org.opencv.core.Scalar;
import org.opencv.core.MatOfPoint;
import org.opencv.core.MatOfPoint2f;
import org.opencv.core.Point;
import org.opencv.core.Rect;

import tomerblecher.yuvtransform.YuvConverter;

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
                            int width = call.argument("width");
                            int height = call.argument("height");
                            byte[] data = YuvConverter.NV21toJPEG(
                                    YuvConverter.YUVtoNV21(bytesList, strides, width, height), width, height, 100);
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

                            int[][] pointsValue = new int[][] { { 0, 0, 100, 100, 1 },
                                    { max_width - 100, 0, 100, 100, 2 }, { 0, max_height - 100, 100, 100, 3 },
                                    { max_width - 100, max_height - 100, 100, 100, 4 }, };

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
                                    if (area > 100 && area < 300) {
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
                                            }
                                            if (pointsValue[i][4] == 2) {
                                                pointsValue[i][0] = pointsValue[i][0] + x;
                                                pointsValue[i][1] = pointsValue[i][1] + y;
                                                pointsValue[i][2] = rectangle.width;
                                                pointsValue[i][3] = rectangle.height;
                                            }
                                            if (pointsValue[i][4] == 3) {
                                                pointsValue[i][0] = x;
                                                pointsValue[i][1] = pointsValue[i][1] + y;
                                                pointsValue[i][2] = rectangle.width;
                                                pointsValue[i][3] = rectangle.height;
                                            }
                                            if (pointsValue[i][4] == 4) {
                                                pointsValue[i][0] = pointsValue[i][0] + x;
                                                pointsValue[i][1] = pointsValue[i][1] + y;
                                                pointsValue[i][2] = rectangle.width;
                                                pointsValue[i][3] = rectangle.height;
                                            }

                                            break innerLoop;
                                        }
                                    }
                                }
                            }

                            mRgba.release();
                            mRgbaCopy.release(); //
                            result.success("{\"width\": " + max_width + ", \"height\": " + max_height + ", \"points\": "
                                    + Arrays.deepToString(pointsValue) + " , \"answer\": false }");
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
        return directory.getAbsolutePath();
    }

}
