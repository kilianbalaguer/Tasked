import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: false)],
        animation: .default)
    private var items: FetchedResults<Item>

    @State private var showingAddItemView = false
    @State private var showingSettingsView = false

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(items) { item in
                        VStack(alignment: .leading) {
                            Text(item.title ?? "Untitled")
                                .font(.headline)
                            if let date = item.timestamp {
                                Text(date, formatter: itemFormatter)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(UIColor.systemBackground).opacity(0.9))
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                    }
                    .onDelete(perform: deleteItems)
                }
                
                Button(action: {
                    showingAddItemView = true
                }) {
                    Text("Add New Tasked")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding()
                }
            }
            .sheet(isPresented: $showingAddItemView) {
                AddItemView().environment(\.managedObjectContext, viewContext)
            }
            .sheet(isPresented: $showingSettingsView) {
                SettingsView()
            }
            .navigationTitle("Tasked List")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showingSettingsView = true }) {
                        Label("Settings", systemImage: "gear")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
