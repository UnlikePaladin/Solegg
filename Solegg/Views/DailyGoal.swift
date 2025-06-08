//
//  DailyGoal.swift
//  Solegg
//
//  Created by Alexa Nohemi Lara Carvajal on 07/06/25.
//
import SwiftUI

struct DailyGoal: View {
    @ObservedObject var viewModel : Steps
    var body: some View {
        ScrollView{
            VStack(spacing:60){
                ForEach(Array(viewModel.goals.enumerated()), id:\.element.id) { index, goal in
                    HStack{
                        if index % 2==0{
                            Bubble(goal: goal)
                            Spacer()
                        } else {
                            Spacer()
                            Bubble(goal : goal)
                        }
                    }
                    .padding(.horizontal)
                }
                
            }
            .padding(.vertical)
        }
    }
}


#Preview {
    DailyGoal(viewModel: Steps())
}
