import WidgetKit
import SwiftUI

struct Entry: TimelineEntry {
    let date: Date
    let category: String

    init(date: Date, category: String) {
        self.date = date
        self.category = category.capitalized
    }
}

struct Provider: TimelineProvider {

    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), category: "")
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry(date: Date(), category: "Category")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        Task {
            let category = NewsCategory.random
            guard let posted = try? await getTime(category: category) else { return }
            let entry = Entry(date: posted, category: category)
            guard let nextUpdate = Calendar.current.date(byAdding: DateComponents(minute: 360),
                                                         to: Date()) else { return }
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    // swiftlint:disable line_length
    func getTime(category: String) async throws -> Date {
        let link = "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&pageSize=100&apiKey=8f825354e7354c71829cfb4cb15c4893"

        guard let url = URL(string: link) else { return Date() }
        let (data, _) = try await URLSession.shared.data(from: url)
        let model = try JSONDecoder().decode(CommonInfo.self, from: data)
        let date = model.articles?.first?.publishedAt?.getDate()
        return date ?? Date()
    }
    // swiftlint:enable line_length
}

struct SmallView: View {
    let entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack {
                Text(entry.category)
                    .fontDesign(.monospaced)
                    .font(.subheadline)
                    .foregroundStyle(.gray)

                Divider()
                    .frame(width: 100)

                Text(entry.date, style: .time)
                    .fontDesign(.monospaced)
                    .font(.title)
                    .foregroundStyle(.gray)
            }
        }
    }
}

struct AccessoryCircularView: View {
    let entry: Provider.Entry

    var body: some View {
        ZStack {
            Color.black.clipShape(.circle)
            VStack {
                Text(entry.category.prefix(4))
                    .fontDesign(.monospaced)
                    .font(.system(size: 11))
                    .padding(EdgeInsets(top: .zero,
                                        leading: 7,
                                        bottom: .zero,
                                        trailing: 7))
                    .lineLimit(1)

                Divider()
                    .frame(width: 40)

                Text(entry.date, style: .time)
                    .fontDesign(.monospaced)
                    .font(.system(size: 11))
                    .padding(EdgeInsets(top: -3,
                                        leading: 7,
                                        bottom: .zero,
                                        trailing: 7))
            }
        }
    }
}

struct AccessoryInlineView: View {
    let entry: Provider.Entry

    var body: some View {
        Text(entry.category + .spacer + entry.date.getTime())
    }
}

struct AccessoryRectangularView: View {
    let entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.category)
                .fontDesign(.monospaced)
                .font(.system(size: 16))
                .lineLimit(1)

            Divider()
                .frame(width: 70)

            Text(entry.date, style: .time)
                .fontDesign(.monospaced)
                .font(.system(size: 16))
                .lineLimit(1)
        }
        .padding(.vertical)
    }
}

struct NewsWidgetEntryView: View {
    @Environment(\.widgetFamily) var family

    let entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        VStack {
            switch family {
            case .systemSmall: SmallView(entry: entry)
            case .accessoryCircular: AccessoryCircularView(entry: entry)
            case .accessoryInline: AccessoryInlineView(entry: entry)
            case .accessoryRectangular: AccessoryRectangularView(entry: entry)
            default:
                Text("Need configure")
                    .fontDesign(.monospaced)
                    .font(.headline)
            }
        }
        .transition(.push(from: .bottom))
    }
}

struct NewsWidgets: Widget {
    let kind: String = "NewsWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                NewsWidgetEntryView(entry: entry)
                    .containerBackground(.background, for: .widget)

            } else {
                NewsWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("News widget")
        .description("Stay in touch")
        .supportedFamilies([
            .systemSmall,
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
    Entry(date: .now, category: NewsCategory.random)
}
#endif
