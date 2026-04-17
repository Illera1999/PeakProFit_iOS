import SwiftUI
import FirebaseAuth

struct SavedExercisesListView: View {
    @State private var session = SessionViewModel.shared
    @State private var viewModel = SavedExercisesListViewModel()

    var body: some View {
        List {
            ForEach(viewModel.exercises, id: \.id) { exercise in
                ZStack {
                    CardView(exercise: exercise)

                    NavigationLink {
                        SavedExerciseDetailPage(exercise: exercise)
                    } label: {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .overlay {
            if viewModel.isLoading && viewModel.exercises.isEmpty {
                ProgressView("Loading saved exercises...")
            } else if let error = viewModel.errorMessage, viewModel.exercises.isEmpty {
                VStack(spacing: 8) {
                    Text(error).foregroundStyle(.red)
                    Button("Try again") {
                        viewModel.loadFavorites(userId: session.currentUser?.uid)
                    }
                }
            } else if viewModel.exercises.isEmpty {
                ContentUnavailableView("No saved exercises yet", systemImage: "bookmark")
            }
        }
        .task(id: session.currentUser?.uid) {
            viewModel.loadFavorites(userId: session.currentUser?.uid)
        }
        .onReceive(NotificationCenter.default.publisher(for: .favoritesDidChange)) { _ in
            viewModel.loadFavorites(userId: session.currentUser?.uid)
        }
        .refreshable {
            viewModel.loadFavorites(userId: session.currentUser?.uid)
        }
    }
}

struct SavedExerciseDetailPage: View {
    let exercise: ExerciseEntity

    @State private var session = SessionViewModel.shared
    @State private var detailViewModel: ExerciseDetailViewModel
    @State private var personalNote = ""
    @State private var editableNote = ""
    @State private var storedInstructions: [String] = []

    private let favoritesStore = FavoritesStore.shared
    private let maxNoteLength = 124

    init(exercise: ExerciseEntity) {
        self.exercise = exercise
        _detailViewModel = State(initialValue: ExerciseDetailViewModel(exerciseID: exercise.id))
    }

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Saved Details", showsBackButton: true)

            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text(exercise.name.capitalizedFirstLetter)
                        .stylePageTitle()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    if let difficulty = resolvedDifficulty {
                        DetailSectionView(title: "Difficulty") {
                            TagPillView(title: difficulty)
                        }
                    }

                    DetailSectionView(title: "Instructions") {
                        if visibleInstructions.isEmpty {
                            Text("No instructions available")
                                .styleSubtitle()
                        } else {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(Array(visibleInstructions.enumerated()), id: \.offset) { index, instruction in
                                    Text("\(index + 1). \(instruction.capitalizedFirstLetter)")
                                        .styleSubtitle()
                                }
                            }
                        }
                    }

                    DetailSectionView(title: "Your note") {
                        VStack(alignment: .leading, spacing: 10) {
                            TextEditor(text: $editableNote)
                                .frame(minHeight: 110)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .fill(Color.white)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .stroke(Color(.systemGray4), lineWidth: 1)
                                )
                                .onChange(of: editableNote) { _, newValue in
                                    if newValue.count > maxNoteLength {
                                        editableNote = String(newValue.prefix(maxNoteLength))
                                    }
                                }

                            HStack {
                                Spacer()
                                Text("\(editableNote.count)/\(maxNoteLength)")
                                    .font(.custom("Lexend-Medium", size: 12))
                                    .foregroundStyle(Color("ColorTextSecondary"))
                            }

                            Button("Guardar") {
                                saveNote()
                            }
                            .font(.custom("Lexend-Medium", size: 14))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12, style: .continuous)
                                    .fill(Color("ColorBrandGreen"))
                            )
                            .buttonStyle(.plain)
                            .disabled(session.currentUser?.uid == nil || personalNote == editableNote)
                            .opacity(session.currentUser?.uid == nil || personalNote == editableNote ? 0.5 : 1)
                        }
                    }
                }
                .padding(16)
            }
            .overlay {
                if detailViewModel.isLoading && detailViewModel.exercise == nil && visibleInstructions.isEmpty {
                    ProgressView("Loading details...")
                }
            }
        }
        .background(Color(.systemGray6).ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task(id: "\(session.currentUser?.uid ?? "")-\(exercise.id)") {
            loadSavedData()
            if detailViewModel.exercise == nil {
                await detailViewModel.loadExercise()
            }
            persistFetchedExerciseInfoIfNeeded()
        }
    }

    private var visibleInstructions: [String] {
        let fetched = detailViewModel.exercise?.instructions ?? []
        return fetched.isEmpty ? storedInstructions : fetched
    }

    private var resolvedDifficulty: String? {
        if let fetched = detailViewModel.exercise?.difficulty,
           !fetched.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return fetched
        }

        return exercise.difficulty
    }

    private func loadSavedData() {
        guard let userId = session.currentUser?.uid else { return }

        personalNote = favoritesStore.fetchPersonalNote(userId: userId, exerciseId: exercise.id)
        editableNote = personalNote
        storedInstructions = favoritesStore.fetchStoredInstructions(userId: userId, exerciseId: exercise.id)
    }

    private func persistFetchedExerciseInfoIfNeeded() {
        guard let userId = session.currentUser?.uid,
              let exerciseDetail = detailViewModel.exercise else { return }

        do {
            try favoritesStore.updateStoredExerciseInfo(
                userId: userId,
                exerciseId: exercise.id,
                instructions: exerciseDetail.instructions,
                difficulty: exerciseDetail.difficulty
            )
            storedInstructions = favoritesStore.fetchStoredInstructions(userId: userId, exerciseId: exercise.id)
        } catch {
            print("[SavedExerciseDetailPage] Failed to persist exercise info: \(error.localizedDescription)")
        }
    }

    private func saveNote() {
        guard let userId = session.currentUser?.uid else { return }

        let note = String(editableNote.prefix(maxNoteLength))
        editableNote = note

        do {
            try favoritesStore.updatePersonalNote(userId: userId, exerciseId: exercise.id, note: note)
            personalNote = note
            SnackbarCenter.shared.show(message: "Note saved.", style: .success)
        } catch {
            print("[SavedExerciseDetailPage] Failed to save note: \(error.localizedDescription)")
            SnackbarCenter.shared.show(message: "Couldn't save your note.", style: .error)
        }
    }
}

#Preview {
    NavigationStack {
        SavedExercisesListView()
    }
}
