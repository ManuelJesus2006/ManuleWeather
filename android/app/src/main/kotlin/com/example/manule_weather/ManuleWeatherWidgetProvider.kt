package com.example.manule_weather // 👈 Asegúrate de que coincida con tu paquete

import com.example.manule_weather.R 
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import es.antonborri.home_widget.HomeWidgetProvider

class ManuleWeatherWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        appWidgetIds.forEach { widgetId ->
            // Buscamos el marco que creamos (widget_layout)
            val views = android.widget.RemoteViews(context.packageName, R.layout.widget_layout).apply {
                // Le metemos la foto que se generó desde Flutter usando tu KEY
                val imageName = widgetData.getString("ManuleWeather_Widget", null)
                if (imageName != null) {
                    setImageViewBitmap(R.id.ManuleWeather_Widget, android.graphics.BitmapFactory.decodeFile(imageName))
                }
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}