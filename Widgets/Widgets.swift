//
//  Widgets.swift
//  Widgets
//
//  Created by donghyun on 2021/06/06.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent(), event: nil)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, event: nil)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let storage = LocalEventStorage()
        let id = UserDefaults.standard.double(forKey: "widget")
        let event = storage.find(by: id)
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, event: event)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let event: Event?
}

struct WidgetsEntryView : View {
    var entry: Provider.Entry
    
    var event: Event? {
        Event(icon: 1, title: "Sample", date: Date(timeIntervalSinceNow: 10000000))
    }
    
    var body: some View {
        if let event = event {
            VStack {
                Spacer()
                
                HStack {
                    Spacer().frame(height: 15)
                    Image("icon_\(event.icon)").resizable().frame(width: 50, height: 50)
                    Spacer().frame(width: 15)
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    if event.dayCount() == 0 {
                        Text("Today").font(.headline)
                    } else {
                        let prefix = event.dayCount() > 0 ? "D+" : "D-"
                        Text("\(prefix)\(abs(event.dayCount()))").font(.system(size: 20, weight: .bold))
                    }
                    Text(event.date, style: .date).font(.system(size: 10, weight: .bold)).foregroundColor(.gray).frame(maxWidth:. infinity, alignment: .leading)
                }.padding(20)
            }
        } else {
            Text("No Event")
        }
    }
}

@main
struct Widgets: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Widgets_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), event: Event(icon: 1, title: "Sample", date: Date(timeIntervalSinceNow: 10000000))))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}