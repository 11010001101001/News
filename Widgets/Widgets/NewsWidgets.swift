import LocalizationKit
import ModelsKit
import SwiftData
import SwiftUI
import WidgetKit

struct NewsWidgets: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "NewsWidget", provider: Provider()) { entry in
            NewsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Strings.widgetsTitle)
        .description(Strings.widgetsMotivation)
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
        Entry(
            category: NewsCategory.technology.displayName,
            level: .techNinja,
            procentsToNextLevel: 45,
            lastViewedTitle: "test topic"
        )
    }
#endif
