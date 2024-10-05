package com.example.my_wallpaper_app

import android.app.WallpaperManager
import android.graphics.BitmapFactory
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream
import java.io.IOException

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.my_wallpaper_app/wallpaper"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "setWallpaperDirectly") {
                val filePath = call.argument<String>("filePath")
                if (filePath != null) {
                    try {
                        setWallpaper(filePath)
                        result.success("success")
                    } catch (e: Exception) {
                        result.error("UNAVAILABLE", "Failed to set wallpaper: ${e.message}", null)
                    }
                } else {
                    result.error("INVALID_ARGUMENT", "File path is null", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Function to set wallpaper directly from a file path
    private fun setWallpaper(filePath: String) {
        println("Setting wallpaper to $filePath")
        val file = File(filePath)
        if (!file.exists()) {
            println("File does not exist")
            throw IOException("File does not exist")
        }

        var inputStream: FileInputStream? = null
        try {
            inputStream = FileInputStream(file)
            val wallpaperManager = WallpaperManager.getInstance(applicationContext)
            wallpaperManager.setStream(inputStream)
            println("Wallpaper set successfully")
        } catch (e: IOException) {
            println("IOException: ${e.message}")
            e.printStackTrace()
            throw e
        } catch (e: IllegalArgumentException) {
            println("IllegalArgumentException: ${e.message}")
            e.printStackTrace()
            throw e
        } catch (e: OutOfMemoryError) {
            println("OutOfMemoryError: ${e.message}")
            e.printStackTrace()
            throw IOException("Image too large to set as wallpaper")
        } finally {
            inputStream?.close()
        }
    }
}