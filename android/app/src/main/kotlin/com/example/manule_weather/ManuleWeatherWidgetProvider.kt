package com.example.manule_weather

import com.example.manule_weather.R 
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import es.antonborri.home_widget.HomeWidgetProvider
import es.antonborri.home_widget.HomeWidgetLaunchIntent // 👈 1. Añadimos este import

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

                //PARA QUE EJECUTE LA APP AL PULSAR EL WIDGET EN LOS MOVILES ANDROID CONFLICTIVOS:
                //Generamos el PendingIntent para abrir MainActivity
                val pendingIntent = HomeWidgetLaunchIntent.getActivity(
                    context,
                    MainActivity::class.java
                )

                //Se lo asignamos al ImageView para que al pulsarlo abra la app
                setOnClickPendingIntent(R.id.ManuleWeather_Widget, pendingIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}