package com.toedok

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                "toedok_foreground_channel",
                "Toedok Foreground Service",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)

            // 분석 알림 채널 추가
            val analysisChannel = NotificationChannel(
                "toedok_analysis_channel",
                "Toedok Analysis",
                NotificationManager.IMPORTANCE_DEFAULT
            )
            manager.createNotificationChannel(analysisChannel)
        }
    }
}