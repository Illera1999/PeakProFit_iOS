import SwiftUI

struct SavedExercisesPage: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Saved Exercises", showsBackButton: true)
            SavedExercisesListView()
        }
        .background(Color("ColorAppBackground").ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        SavedExercisesPage()
    }
}
