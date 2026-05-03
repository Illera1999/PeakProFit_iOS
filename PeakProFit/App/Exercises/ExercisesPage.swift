//
//  ExercisesPage.swift
//  PeakProFit
//
//  Created by Jose Manuel Illera Rodríguez on 22/3/26.
//

import SwiftUI

struct ExercisesPage: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 0) {
                HeaderView(title: "Exercises")
                ExercisesListView()
            }
            .background(Color("ColorAppBackground").ignoresSafeArea())
        }
    }

}

#Preview {
    ExercisesPage()
}
