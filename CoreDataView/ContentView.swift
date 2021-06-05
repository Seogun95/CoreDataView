//
//  ContentView.swift
//  CoreDataView
//
//  Created by Seogun Kim on 2021/06/05.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: FoodEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \FoodEntity.name, ascending: true)])
    var Food: FetchedResults<FoodEntity>
    
    @State var textFieldTitle: String = ""
    
    var body: some View {
        
        NavigationView {
            
            VStack(spacing: 10) {
                TextField("", text: $textFieldTitle)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground).cornerRadius(10))
                    .padding(.horizontal, 10)
                
                Button(action: {addItem()}, label: {
                    Text("저장")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .foregroundColor(.white)
                        .background(Color("Peach").cornerRadius(10))
                        .padding(.horizontal, 10)
                    
                })
                
                List {
                    ForEach(Food) { foods in
                        //과일에 이름이 없으면 빈문자열을 생성
                        Text(foods.name ?? "아이템 없음")
                            .onTapGesture {
                                updateItems(food: foods)
                            }
                    }
                    .onDelete(perform: deleteItems)
                }
                
                .listStyle(PlainListStyle())
                .navigationBarTitle("음식")
            }
            
        }
    }
    
    private func updateItems(food: FoodEntity) {
        let currentName = food.name ?? ""
        let newName = currentName + "!"
        food.name = newName
        saveItems()
    }
    
    private func addItem() {
        withAnimation {
            //수정 부분
            let newFood = FoodEntity(context: viewContext)
            newFood.name = textFieldTitle
            //textFieldTitle을 사용 후 재설정
            textFieldTitle = ""
            
            saveItems()
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            
            guard let index = offsets.first else { return }
            let FoodEntity = Food[index]
            viewContext.delete(FoodEntity)
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
