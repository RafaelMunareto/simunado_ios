import SwiftUI

struct GabaritoResumoView: View {
    let resumo: ResultadoResumo
    let liquidoBasico: Int?
    let liquidoEspecifico: Int?
    let parteAtual: String // precisa passar isso
    
    @State private var copied = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text("GABARITO - \(parteAtual.uppercased())")
                .font(.headline)
                .foregroundColor(.primary)
            
            HStack(spacing: 16) {
                Label("Acertos: \(resumo.acertos)", systemImage: "checkmark")
                    .foregroundColor(.green)
                Label("Erros: \(resumo.erros)", systemImage: "xmark")
                    .foregroundColor(.red)
                Label("Não Respondidas: \(resumo.vazios)", systemImage: "square")
                    .foregroundColor(.gray)
            }
            
            Text("Pontuação líquida: \(resumo.total)")
                .font(.headline)
                .foregroundColor(resumo.total >= 0 ? .green : .red)
            
            Divider()
            
            Text("Nota Final:\n\(liquidoBasico ?? 0) + (2 × \(liquidoEspecifico ?? 0)) = \(liquidoBasico ?? 0 + 2 * (liquidoEspecifico ?? 0))")
                .multilineTextAlignment(.center)
            
            Button(action: {
                let texto = """
                GABARITO \(parteAtual.uppercased()):
                Acertos: \(resumo.acertos)
                Erros: \(resumo.erros)
                Não Respondidas: \(resumo.vazios)
                Pontuação líquida: \(resumo.total)
                Nota Final: \(liquidoBasico ?? 0) + (2 × \(liquidoEspecifico ?? 0)) = \(liquidoBasico ?? 0 + 2 * (liquidoEspecifico ?? 0))
                """
                UIPasteboard.general.string = texto
                copied = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    copied = false
                }
            }) {
                Image(systemName: copied ? "checkmark" : "doc.on.doc")
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}
