//
//  Prova.swift
//  p_estudo
//
//  Created by Rafael Menezes Munareto on 29/06/25.
//


import Foundation

struct Prova: Codable {
    let titulo: String
    let texto: Texto?
    let temas: [Tema]
}

struct Texto: Codable {
    let titulo: String
    let linhas: [String]
}

struct Tema: Codable {
    let nome: String
    let questoes: [Questao]
}

struct Questao: Codable, Identifiable {
    let id: Int
    let enunciado: String
    let gabarito: String
}
