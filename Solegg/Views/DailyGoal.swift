//
//  DailyGoal.swift
//  Solegg
//
//
import SwiftUI


struct DailyGoal: View {
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    @State var expDaily = Int()
    @ObservedObject var viewModel : Steps
    var body: some View {
        ScrollView{
            VStack(spacing:60){
                Spacer()
                Text ("Daily challenge").font(.title).bold()
                ForEach($viewModel.goals.enumerated().map { $0 }, id: \.1.id) { index, $goal in
                    HStack {
                        Spacer(minLength: 20)
                        if index % 2 == 1 {
                            Bubble(goal: $viewModel.goals[index])
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.3, alignment: .trailing)
                            Spacer(minLength: 30)
                        } else {
                            Spacer(minLength: 30)
                            Bubble(goal: $viewModel.goals[index]).frame(maxWidth: UIScreen.main.bounds.width * 0.3, alignment: .trailing)
                        }
                        Spacer()
                    }
                }
                
            }
            .padding(.vertical)
        }
    }
}


#Preview {
    DailyGoal(viewModel: Steps())
}
