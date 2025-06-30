import SwiftUI

struct QuestoesView: View {
    let parte: Prova
    @ObservedObject var respostasManager: RespostasManager
    let corrigido: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if let texto = parte.texto {
                VStack(alignment: .leading, spacing: 8) {
                    Text(texto.titulo)
                        .font(.title3.bold())
                        .multilineTextAlignment(.center)
                        .padding(.vertical)
                    
                    ForEach(Array(texto.linhas.enumerated()), id: \.offset) { i, linha in
                        Text("\(i + 1). \(linha)")
                            .font(.body)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal)
            }

            
            ForEach(parte.temas, id: \.nome) { tema in
              
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Spacer()
                        Text(tema.nome)
                            .font(.headline)
                            .foregroundColor(Color.blue)
                        Spacer()
                    }
                   
                    Divider()
                        .background(Color.white)
                    ForEach(tema.questoes) { questao in
                        QuestaoRow(
                            questao: questao,
                            respostasManager: respostasManager,
                            corrigido: corrigido
                        )
                        
                    }
                }.padding(.top)
               
            }

           
        }
        .padding()
    }
}



struct QuestoesView_Previews: PreviewProvider {
    static var previews: some View {
        // Questões de exemplo
        let exemploQuestao1 = Questao(
            id: 1,
            enunciado: "O que é SwiftUI O que é SwiftUI O que é SwiftUI O que é SwiftUI O que é SwiftUI?",
            gabarito: "C"
        )
        
        let exemploQuestao2 = Questao(
            id: 2,
            enunciado: "SwiftUI substitui UIKit?",
            gabarito: "E"
        )
        
        // Tema de exemplo
        let exemploTema = Tema(
            nome: "Tecnologia",
            questoes: [exemploQuestao1, exemploQuestao2]
        )
        
        // Texto de instrução
        let exemploTexto = Texto(
            titulo: "Prova de Conhecimentos Gerais",
            linhas: [
                "Responda todas as questões.",
                "Cada questão vale 1 ponto."
            ]
        )
        
        // Prova completa
        let exemploProva = Prova(
            titulo: "Simulado",
            texto: exemploTexto,
            temas: [exemploTema]
        )
        
        // View de preview
        return QuestoesView(
            parte: exemploProva,
            respostasManager: RespostasManager(),
            corrigido: false
        )
        .previewLayout(.sizeThatFits)
    }
}
