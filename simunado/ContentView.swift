import SwiftUI

struct ContentView: View {
    @State private var provasDisponiveis = ["prova_1", "prova_2", "prova_3"]
    @State private var provaSelecionada = "prova_1"
    @State private var prova: [String: Prova]? = nil
    @State private var parteAtual = "basicos"
    @State private var corrigidoBasico = false
    @State private var corrigidoEspecifico = false
    @State private var resultadoResumoBasico: ResultadoResumo?
    @State private var resultadoResumoEspecifico: ResultadoResumo?
    @State private var liquidoBasico: Int?
    @State private var liquidoEspecifico: Int?
    
    @StateObject private var respostasManager = RespostasManager()
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 8) {
                Text("SIMUNADO")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color.blue)
                    .padding(.top, 12)
                
//                Picker("Prova", selection: $provaSelecionada) {
//                    ForEach(provasDisponiveis, id: \.self) { p in
//                        Text(p.capitalized)
//                    }
//                }
//                .pickerStyle(MenuPickerStyle())
                
                Picker("Parte", selection: $parteAtual) {
                    Text("BÁSICO").tag("basicos")
                    Text("ESPECÍFICO").tag("especificos")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(8)
            }
            .background(Color(.systemBackground))
            .zIndex(1)
            
            Divider()
            
            ScrollView {
                VStack {
                    if let prova = prova?[parteAtual] {
                        QuestoesView(
                            parte: prova,
                            respostasManager: respostasManager,
                            corrigido: parteAtual == "basicos" ? corrigidoBasico : corrigidoEspecifico
                        )
                    }
                    
                    HStack {
                        Button("Gerar Gabarito") {
                            if parteAtual == "basicos" {
                                corrigir(parte: "basicos")
                            } else {
                                corrigir(parte: "basicos")
                                corrigir(parte: "especificos")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button("Limpar Respostas") {
                            respostasManager.limpar()
                            corrigidoBasico = false
                            corrigidoEspecifico = false
                            resultadoResumoBasico = nil
                            resultadoResumoEspecifico = nil
                            liquidoBasico = nil
                            liquidoEspecifico = nil
                        }
                        .buttonStyle(.bordered)
                        .background( Color(.systemGray3))
                        .foregroundColor(.primary)
                    }
                    .padding()
                    
                    if parteAtual == "basicos" {
                        if let resumo = resultadoResumoBasico {
                            GabaritoResumoSimplesView(
                                resumo: resumo,
                                liquidoBasico: liquidoBasico,
                                liquidoEspecifico: liquidoEspecifico
                            )
                            .padding()
                        }
                    } else {
                        VStack(spacing: 20) {
                            if let resumoBasico = resultadoResumoBasico {
                                GabaritoResumoSimplesView(
                                    resumo: resumoBasico,
                                    liquidoBasico: liquidoBasico,
                                    liquidoEspecifico: liquidoEspecifico
                                )
                            }
                            if let resumoEspecifico = resultadoResumoEspecifico {
                                GabaritoResumoSimplesView(
                                    resumo: resumoEspecifico,
                                    liquidoBasico: liquidoBasico,
                                    liquidoEspecifico: liquidoEspecifico
                                )
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .onAppear {
            respostasManager.carregar()
            carregar()
        }
    }
    
    func carregar() {
        if let provaCarregada = carregarProva(nomeArquivo: provaSelecionada) {
            prova = provaCarregada
        }
    }
    
    func corrigir(parte: String) {
        guard let prova = prova?[parte] else { return }
        
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
        
        let resumo = ResultadoResumo(
            acertos: acertos,
            erros: erros,
            vazios: vazios,
            total: total, temas: []
        )
        
        if parte == "basicos" {
            liquidoBasico = total
            resultadoResumoBasico = resumo
            corrigidoBasico = true
        } else {
            liquidoEspecifico = total
            resultadoResumoEspecifico = resumo
            corrigidoEspecifico = true
        }
    }
}



struct ResultadoResumo {
    let acertos: Int
    let erros: Int
    let vazios: Int
    let total: Int
    let temas: [TemaResumo]
}

struct TemaResumo: Identifiable {
    let id = UUID()
    let nome: String
    let acertos: Int
    let erros: Int
    let vazios: Int
    var liquido: Int { acertos - erros }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
