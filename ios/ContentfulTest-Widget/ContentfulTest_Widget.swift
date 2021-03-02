//
//  ContentfulTest_Widget.swift
//  ContentfulTest-Widget
//
//  Created by Austin Jones on 3/2/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: Date(), configuration: ConfigurationIntent(), name: "Placeholder name")
  }
  
  func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration, name: "Snapshot name")
    completion(entry)
  }
  
  func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    let contentfulManager = ContentfulManager()
    contentfulManager.fetchData() { (output) in
      var entries: [SimpleEntry] = []
      let currentDate = Date()
      
      // 0 - 5 refer to minutes since we are doing "byAdding: .minute"
      // The data from Contentful is re-fetched every 5 minutes
      for offset in 0 ..< 5 {
        let entryDate = Calendar.current.date(byAdding: .minute, value: offset, to: currentDate)!
        let entry = SimpleEntry(date: entryDate, configuration: configuration, name: output)
        entries.append(entry)
      }
      
      let timeline = Timeline(entries: entries, policy: .atEnd)
      completion(timeline)
    }
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let configuration: ConfigurationIntent
  let name: String
}

struct ContentfulTest_WidgetEntryView : View {
  var entry: Provider.Entry
  
  var body: some View {
    Text(entry.date, style: .time)
    Text(entry.name)
  }
}

@main
struct ContentfulTest_Widget: Widget {
  let kind: String = "ContentfulTest_Widget"
  
  var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
      ContentfulTest_WidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct ContentfulTest_Widget_Previews: PreviewProvider {
  static var previews: some View {
    ContentfulTest_WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent(), name: ""))
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
