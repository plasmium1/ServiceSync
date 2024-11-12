import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var items = placeholderPostArray
    @State private var isDisclosed = false
    @State private var focusProgram = false
    @State private var focusContent = true
    @State private var offset = 0
    @State private var count = 0
    
    
    
    
    @State private var stateOfFilters = filters
    
     var filteredItems: [Post] {
        if searchText.isEmpty {
            var tempItems = items
            (0...stateOfFilters.count-1) .forEach{ filter in
                if stateOfFilters[filter] == true{
                    (0...items.count-1) .forEach{ post in
                        var canStay = false
                        (0...items[post].getTags().count-1) .forEach{ tag in
                            
                            if items[post].getTags()[tag] == placeholderTagsArray[filter]{
                                canStay = true
                            }
                            
                            
                        }
                        
                        if canStay == false {
                            if tempItems.firstIndex(of: items[post]) != nil {
                                tempItems.remove(at: tempItems.firstIndex(of: items[post])!)
                            }
                        }
                    }
                }
            }
            return tempItems
        } else {
            var results = [placeholderPost3]
            for post in placeholderPostArray{
                
                if focusContent == true{
                    if post.getPostContent().contains(searchText) || post.getPostContent().contains(searchText.lowercased()) {
                        results.append(post)
                        
                    }
                }
                else if focusProgram == true{
                    if post.getTitle().contains(searchText) || post.getTitle().contains(searchText.lowercased())  {
                        results.append(post)
                        
                    }
                }
                
                
                
            }
            
            if results.count > 1 {
                results.removeFirst()
            }
            var tempResults = results
            (0...stateOfFilters.count-1) .forEach{ filter in
                if stateOfFilters[filter] == true{
                    (0...results.count-1) .forEach{ post in
                        var canStay = false
                        (0...results[post].getTags().count-1) .forEach{ tag in
                            
                            if results[post].getTags()[tag] == placeholderTagsArray[filter]{
                                canStay = true
                            }
                            
                            
                        }
                        
                        if canStay == false {
                            if tempResults.firstIndex(of: results[post]) != nil {
                                tempResults.remove(at: tempResults.firstIndex(of: results[post])!)
                            }
                        }
                    }
                }
            }
            
            
            return tempResults
            
            
            
        }
    }
    
    var body: some View {
        VStack {
            
            if filters.count == placeholderTagsArray.count {
                TopBar()
            }
            NavigationView {
               
                
                VStack {
                    // Search bar
                    TextField("Search...", text: $searchText)
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    
                    
                    
                    VStack {
                        Button("Search Options") {
                            withAnimation {
                                isDisclosed.toggle()
                            }
                        }
                        .buttonStyle(.plain)
                        .font(.title3)
                                
                        VStack {
                            VStack{
                                VStack(){
                                    Text("Search By:")
                                        .font(.headline)
                                    
                                    
                                    ZStack {
                                        
                                        Rectangle()
                                            .fill(.green)
                                            .border(.black)
                                            .frame(width: 200, height: 50)
                                            
                                            
                                        
                                        HStack {
                                            Button("Search Programs"){
                                                
                                                if focusContent == true{
                                                    focusContent.toggle()
                                                    focusProgram.toggle()
                                                }
                                                
                                                
                                                
                                            }
                                            .buttonStyle(.plain)
                                            
                                            if focusProgram == true{
                                                Image(systemName: "checkmark.square.fill")
                                            }
                                            else{
                                                Image(systemName: "checkmark.square")
                                            }
                                            
                                        }
                                    }
                                    
                                    ZStack {
                                        
                                        Rectangle()
                                            .fill(.green)
                                            .border(.black)
                                            .frame(width: 200, height: 50)
                                        
                                        HStack {
                                            Button("Search Content"){
                                                
                                                
                                                if focusProgram == true{
                                                    focusContent.toggle()
                                                    focusProgram.toggle()
                                                }
                                            }
                                            .buttonStyle(.plain)
                                            
                                            if focusContent == true{
                                                Image(systemName: "checkmark.square.fill")
                                            }
                                            else{
                                                Image(systemName: "checkmark.square")
                                            }
                                            
                                        }
                                    }
                                    .padding()
                                    
                                    
                                }
                                .padding()
                                
                                
                                
                                
                                
                                VStack() {
                                    Text("Filters:")
                                        .font(.headline)
                                    
                                    VStack {
                                        ForEach(placeholderTagsArray){ tag in
                                            
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 15)
                                                    .fill(tag.getTypeColor())
                                                    .stroke(.black)
                                                    .frame(width: 200, height: 50)
                                                HStack {
                                                    
                                                    
                                                    Button(tag.getName()){
                                                            
                                                        stateOfFilters[placeholderTagsArray.firstIndex(of: tag)!].toggle()
                                                            
                                                        }
                                                        .frame(width: 150, height: 50)
                                                        .font(.system(size:20))
                                                        .buttonStyle(.plain)
                                                    
                                                    if stateOfFilters[placeholderTagsArray.firstIndex(of: tag)!] == true{
                                                        Image(systemName: "checkmark.square.fill")
                                                    }
                                                    else{
                                                        Image(systemName: "checkmark.square")
                                                    }
                                                    
                                                }
                                            }
//                                            .offset(y: CGFloat(integerLiteral: offset))
//                                            
//                                            count = count + 1
                                            
                                            
                                            
                                        }
                                    }
                                    
                                }
                                    }
                            .padding()
                                }
                                .frame(width: isDisclosed ? nil: 0, height: isDisclosed ? nil : 0, alignment: .top)
                                .clipped()
                                
                               
                            }
//                            .frame(maxWidth: .infinity)
                            .background(.thinMaterial)
                            .padding()
                    
                    Divider()
                    // List of filtered results
                    ScrollView{
                        ForEach(filteredItems) { post in
                            HomePostView(post: post)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
        }
        .ignoresSafeArea()
        
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

