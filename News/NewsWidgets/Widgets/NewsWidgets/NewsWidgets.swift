import WidgetKit
import SwiftData
import SwiftUI

struct NewsWidgets: Widget {
    let kind: String = "NewsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NewsWidgetEntryView(entry: entry)
                .containerBackground(.background, for: .widget)
        }
        .configurationDisplayName("News widget")
        .description("Become a tech ninja!")
        .supportedFamilies([
            .systemSmall,
            .systemMedium,
            .systemLarge,
            .systemExtraLarge,
            .accessoryCircular,
            .accessoryInline,
            .accessoryRectangular
        ])
    }
}

#if DEBUG
#Preview(as: .systemSmall) {
    NewsWidgets()
} timeline: {
    Entry(category: NewsCategory.technology.rawValue, level: .techNinja)
}
#endif
