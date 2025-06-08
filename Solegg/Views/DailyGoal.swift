//
//  DailyGoal.swift
//  Solegg
//
//
import SwiftUI

struct DailyGoal: View {
    @ObservedObject var viewModel : Steps
    var body: some View {
        ScrollView{
            VStack(spacing:60){
                Spacer()
                ForEach($viewModel.goals.enumerated().map { $0 }, id: \.1.id) { index, $goal in
                    HStack {
                        if index % 2 == 0 {
                            Spacer(minLength: 30)
                            Bubble(goal: $viewModel.goals[index])

                                .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .leading)
                            Spacer()
                        } else {
                            Spacer()
                            Bubble(goal: $viewModel.goals[index])
                                .frame(maxWidth: UIScreen.main.bounds.width * 0.6, alignment: .trailing)
                            Spacer(minLength: 30)
                        }
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
