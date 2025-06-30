//
//  RespostasManager.swift
//  p_estudo
//
//  Created by Rafael Menezes Munareto on 29/06/25.
//


import Foundation

class RespostasManager: ObservableObject {
    @Published var respostas: [Int: String] = [:]
    @Published var marcados: Set<Int> = []

    func salvar() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(respostas) {
            UserDefaults.standard.set(data, forKey: "respostas")
        }
        UserDefaults.standard.set(Array(marcados), forKey: "marcados")
    }

    func carregar() {
        if let data = UserDefaults.standard.data(forKey: "respostas"),
           let decoded = try? JSONDecoder().decode([Int: String].self, from: data) {
            respostas = decoded
        }
        if let array = UserDefaults.standard.array(forKey: "marcados") as? [Int] {
            marcados = Set(array)
        }
    }

    func limpar() {
        respostas.removeAll()
        marcados.removeAll()
        salvar()
    }
}
