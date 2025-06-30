import Foundation

func carregarProva(nomeArquivo: String) -> [String: Prova]? {
    guard let url = Bundle.main.url(forResource: nomeArquivo, withExtension: "json"),
          let data = try? Data(contentsOf: url) else {
        return nil
    }
    return try? JSONDecoder().decode([String: Prova].self, from: data)
}
