import SwiftUI

struct SavedExercisesPage: View {
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Saved Exercises", showsBackButton: true)
            SavedExercisesListView()
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        SavedExercisesPage()
    }
}

