import SwiftUI

struct GabaritoView: View {
    let prova: Prova
    @ObservedObject var respostasManager: RespostasManager
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    let (acertos, erros, vazios, total) = calcularPontuacao()
                    
                    ForEach(prova.temas, id: \.nome) { tema in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(tema.nome)
                                .font(.headline)
                            ForEach(tema.questoes) { questao in
                                let resposta = respostasManager.respostas[questao.id] ?? ""
                                let correta = questao.gabarito.uppercased()
                                HStack {
                                    Text("\(questao.id). \(String((questao.enunciado ?? "").prefix(50)))...")
                                        .font(.subheadline)
                                    Spacer()
                                    if resposta.isEmpty {
                                        Text("Gabarito: \(correta)")
                                            .foregroundColor(.blue)
                                    } else if resposta == correta {
                                        Text("Certo")
                                            .foregroundColor(.green)
                                    } else {
                                        Text("Errado")
                                            .foregroundColor(.red)
                                    }
                                }
                                .padding(6)
                                .background(resposta != correta && !resposta.isEmpty ? Color.red.opacity(0.2) : Color.clear)
                                .cornerRadius(6)
                            }
                        }
                    }
                    
                    Divider().padding(.vertical, 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Resumo:")
                            .font(.headline)
                        Text("✅ Acertos: \(acertos)")
                        Text("❌ Erros: \(erros)")
                        Text("⬜ Não respondidas: \(vazios)")
                        Text("🎯 Pontuação líquida: \(total)")
                    }
                    .padding(.top, 8)
                }
                .padding()
            }
            .navigationTitle("Gabarito")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fechar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    private func calcularPontuacao() -> (Int, Int, Int, Int) {
        var acertos = 0
        var erros = 0
        var vazios = 0
        var total = 0
        
        for tema in prova.temas {
            for questao in tema.questoes {
                let resposta = respostasManager.respostas[questao.id] ?? ""
                let correta = questao.gabarito.uppercased()
                if resposta.isEmpty {
                    vazios += 1
                } else if resposta == correta {
                    acertos += 1
                    total += 1
                } else {
                    erros += 1
                    total -= 1
                }
            }
        }
        return (acertos, erros, vazios, total)
    }
}
