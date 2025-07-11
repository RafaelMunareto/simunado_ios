//
//  GabaritoResumoSimplesView.swift
//  p_estudo
//
//  Created by Rafael Menezes Munareto on 29/06/25.
//


import SwiftUI

struct GabaritoResumoSimplesView: View {
    let resumo: ResultadoResumo
    let liquidoBasico: Int?
    let liquidoEspecifico: Int?
    let categoria: String?

    var body: some View {
        VStack(spacing: 8) {
            Text(categoria ?? "teste")
                .font(.title2)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                
            HStack {
                Text("✅ Acertos: \(resumo.acertos)")
                Text("❌ Erros: \(resumo.erros)")
                Text("⬜️ Brancos: \(resumo.vazios)")
            }
            .font(.subheadline)

            Text("Pontuação líquida: \(resumo.total)")
                .font(.headline)
                .foregroundColor(resumo.total >= 0 ? .green : .red)

            Divider()

            Text("Nota Final:")
            Text("\(liquidoBasico ?? 0) + (2 × \(liquidoEspecifico ?? 0)) = \((liquidoBasico ?? 0) + 2 * (liquidoEspecifico ?? 0))")
                .font(.headline)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(8)
    }
}
