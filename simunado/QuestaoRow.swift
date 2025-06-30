import SwiftUI

struct QuestaoRow: View {
    let questao: Questao
    @ObservedObject var respostasManager: RespostasManager
    let corrigido: Bool
    
    @State private var copied = false
    
    var body: some View {
        VStack(alignment: .leading) {
            // Enunciado + botão copiar
            HStack(alignment: .top) {
                Text("\(questao.id).")
                    .fontWeight(.bold)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Text(questao.enunciado)
                            .font(.subheadline)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Spacer()
                    }
                    Spacer() 
                }
                
             
                
                Button(action: {
                    UIPasteboard.general.string = questao.enunciado
                    copied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        copied = false
                    }
                }) {
                    Image(systemName: copied ? "checkmark" : "doc.on.doc")
                        .foregroundColor(.blue)
                }
            }
            
            // Botões B, C, E + Ver
            HStack {
                ForEach(["B", "C", "E"], id: \.self) { letra in
                    let selecionado = respostasManager.respostas[questao.id] == letra
                    Button(letra) {
                        if selecionado {
                            respostasManager.respostas[questao.id] = ""
                        } else {
                            respostasManager.respostas[questao.id] = letra
                        }
                        respostasManager.salvar()
                    }
                    .font(.subheadline.bold())
                    .frame(width: 32, height: 32)
                    .background(corFundo(letra, selecionado))
                    .foregroundColor(corTexto(letra, selecionado))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(corBorda(letra, selecionado), lineWidth: 1)
                    )
                    .cornerRadius(6)
                }
                Spacer()
                Button(action: {
                    if respostasManager.marcados.contains(questao.id) {
                        respostasManager.marcados.remove(questao.id)
                    } else {
                        respostasManager.marcados.insert(questao.id)
                    }
                    respostasManager.salvar()
                }) {
                    Text(respostasManager.marcados.contains(questao.id) ? "✅" : "☑️")
                        .font(.subheadline)
                }
            }
            
            // Mostrar gabarito se corrigido e sem resposta
            if corrigido && (respostasManager.respostas[questao.id] ?? "").isEmpty {
                Text("Gabarito: \(questao.gabarito)")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor(), lineWidth: 1)
        )
        .onAppear {
            // Aqui você inicializa a resposta
            if respostasManager.respostas[questao.id] == nil {
                respostasManager.respostas[questao.id] = "B"
                respostasManager.salvar()
            }
        }
    }
    
    // Cor de fundo do botão
    private func corFundo(_ letra: String, _ selecionado: Bool) -> Color {
        guard selecionado else { return Color(.systemGray5) }
        switch letra {
        case "B": return Color.white
        case "C": return Color.blue
        case "E": return Color.red
        default: return Color(.systemGray5)
        }
    }
    
    // Cor do texto do botão
    private func corTexto(_ letra: String, _ selecionado: Bool) -> Color {
        guard selecionado else { return .primary }
        switch letra {
        case "B": return .black
        default: return .white
        }
    }
    
    // Cor da borda do botão
    private func corBorda(_ letra: String, _ selecionado: Bool) -> Color {
        guard selecionado else { return Color(.systemGray3) }
        switch letra {
        case "B": return Color(.systemGray3)
        case "C": return Color.blue
        case "E": return Color.red
        default: return Color(.systemGray3)
        }
    }
    
    // Cor da borda da questão
    private func borderColor() -> Color {
        guard corrigido else { return Color(.systemGray3) }
        let resposta = respostasManager.respostas[questao.id] ?? ""
        let correta = questao.gabarito.uppercased()
        if resposta.isEmpty {
            return Color.white
        } else if resposta != correta {
            return Color.red
        } else {
            return Color.blue
        }
    }
}


struct QuestaoRow_Previews: PreviewProvider {
    static var previews: some View {
        // Questão de exemplo
        let exemploQuestao = Questao(
            id: 1,
            enunciado: "O SwiftUI é um framework declarativo criado pela Apple para construir interfaces de usuário.",
            gabarito: "C"
        )
        
        // RespostasManager simulando resposta correta
        let respostasCorreta = RespostasManager()
        respostasCorreta.respostas[1] = "C"
        
        // RespostasManager simulando resposta errada
        let respostasErrada = RespostasManager()
        respostasErrada.respostas[1] = "E"
        
        // RespostasManager sem resposta
        let respostasVazia = RespostasManager()
        
        return Group {
            VStack(spacing: 12) {
                QuestaoRow(
                    questao: exemploQuestao,
                    respostasManager: respostasCorreta,
                    corrigido: false
                )
                .previewDisplayName("Não Corrigido")
                
                QuestaoRow(
                    questao: exemploQuestao,
                    respostasManager: respostasCorreta,
                    corrigido: true
                )
                .previewDisplayName("Corrigido - Correto")
                
                QuestaoRow(
                    questao: exemploQuestao,
                    respostasManager: respostasErrada,
                    corrigido: true
                )
                .previewDisplayName("Corrigido - Errado")
                
                QuestaoRow(
                    questao: exemploQuestao,
                    respostasManager: respostasVazia,
                    corrigido: true
                )
                .previewDisplayName("Corrigido - Sem Resposta")
            }
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}
