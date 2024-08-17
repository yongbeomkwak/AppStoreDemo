import SwiftUI
import Combine



struct SearchView: View {
    
    var viewModel = SearchViewModel()
   
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    SearchView()
}
