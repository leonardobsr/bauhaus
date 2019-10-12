//
//  QNTests.swift
//  Bauhaus iOS
//
//  Created by Leonardo Reis on 09/10/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import Quick
import Nimble

class QNTests: QuickSpec {
    override func spec() {
        
        // Scenario 1: O jogo deve definir a quantidade de jogadores normais e bots de acordo com a quantidade de jogadores informada pelo jogador
        // Story 3: Eu, Jogador, QUERO poder escolher a quantidade de jogadores em uma partida PARA jogar com meus amigos.
        // Story 4: Eu, Jogador, QUERO poder escolher a quantidade de jogadores em uma partida PARA jogar contra o sistema.
        describe("Que estou na tela de início") {
            context("Eu informei que haverá 1 jogador normal na partida") {
                it ("O jogo deve registrar que existe 1 jogador normal e 3 jogadores do tipo bot") {}
            }
            
            context("Eu informei que haverá 2 jogadores normais na partida") {
                it ("O jogo deve registrar que existe 2 jogadores normais e 2 jogadores do tipo bot") {}
            }
            
            context("Eu informei que haverá 3 jogadores normais na partida") {
                it ("O jogo deve registrar que existe 3 jogadores normais e 1 jogadores do tipo bot") {}
            }
        }
        // End Scenario
        
        // Story 7: Eu, Jogador, QUERO entender as regras do jogo PARA que eu possa jogar sem problemas.
        // Scenario 2: O jogo deve permitir que o jogador tenha acesso ao onboarding de regras a qualquer momento
        describe("Que estou na tela de início") {
            context("Eu dei um tap no botão de regras") {
                it ("O jogo deve exibir o onboarding com as regras do jogo") {}
            }
        }

        describe("Que estou na tela de Board com a partida em execução") {
            context("Eu dei um tap no botão de regras") {
                it ("O jogo deve exibir o onboarding com as regras do jogo") {}
            }
        }

        // Story 3: Eu, Jogador, QUERO que contenha regras e possibilite o uso de estratégias PARA que eu me sinta desafiado.
        // Scenario 2: O jogo deve definir a quantidade de jogadores normais e bots de acordo com a quantidade de jogadores informada pelo jogador
        // Given: Que estou na tela de início
        // When: Eu informei que haverá 1 jogador normal na partida
        // Then: O jogo deve registrar que existe 1 jogador normal e 3 jogadores do tipo bot
        
        // quero receber tres opcoes de peças aleatorias
        // quero que um time para limitar o tempo da jogada
        // fazer um quadrado
        // fazer um retangulo
        // fazer um quadrado grande
        // fazer retangulo grande
        // unir peças feitas
        // reduzir os elementos criados
        // somar quadrados unitarios
        // o jogo deve finalizar no caso de algum jogador fazer 3 blocos de elementos
        
        // Given: Que estou na tela de início
        // When: Eu informei que haverá 2 jogadores normais na partida
        // Then: O jogo deve registrar que existe 2 jogadores normais e 2 jogadores do tipo bot
        
        // Given: Que estou na tela de início
        // When: Eu informei que haverá 3 jogadores normais na partida
        // Then: O jogo deve registrar que existe 3 jogadores normais e 1 jogadores do tipo bot
        
        
        
        // Story 5: Eu, Jogador, QUERO poder criar uma arte colaborativa no jogo PARA proporcionar engajamento com outras pessoas.
        // Story 6: Eu, Jogador, QUERO poder obter a arte gerada pelo jogo PARA que eu possa compartilhá-la.
        // Scenario 4: O jogo deve definir a quantidade de jogadores normais e bots de acordo com a quantidade de jogadores informada pelo jogador
        // Given: Que estou na tela de início
        // When: Eu informei que haverá 1 jogador normal na partida
        // Then: O jogo deve registrar que existe 1 jogador normal e 3 jogadores do tipo bot
        
        // Given: Que estou na tela de início
        // When: Eu informei que haverá 2 jogadores normais na partida
        // Then: O jogo deve registrar que existe 2 jogadores normais e 2 jogadores do tipo bot
        
        // Given: Que estou na tela de início
        // When: Eu informei que haverá 3 jogadores normais na partida
        // Then: O jogo deve registrar que existe 3 jogadores normais e 1 jogadores do tipo bot
        
        
        
        // Story 1: Eu, Jogador, QUERO um aplicativo de interface simples, intuitiva e esteticamente agradável PARA que eu possa utilizar meu tempo disponível de forma proveitosa.
    }
}

