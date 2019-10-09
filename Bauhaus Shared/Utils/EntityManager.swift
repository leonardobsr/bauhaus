//
//  EntityManager.swift
//  Bauhaus Shared
//
//  Created by Leonardo Reis on 07/10/19.
//  Copyright © 2019 leonardobsr. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    var entities = Set<GKEntity>()
    var toRemove = Set<GKEntity>()
    let scene: SKScene

//    lazy var componentSystems: [GKComponentSystem] = {
//        let boardSystem = GKComponentSystem(componentClass: BoardComponent.self)
//        let dotSystem = GKComponentSystem(componentClass: DotComponent.self)
//        return [boardSystem, dotSystem]
//    }()

    init(scene: SKScene) {
        self.scene = scene
    }

    func add(_ entity: GKEntity) {
        entities.insert(entity)
        
//        for componentSystem in componentSystems {
//            componentSystem.addComponent(foundIn: entity)
//        }

        if let node = entity.component(ofType: RenderComponent.self)?.node {
            scene.addChild(node)
        }
    }

    func remove(_ entity: GKEntity) {
        if let node = entity.component(ofType: RenderComponent.self)?.node {
            node.removeFromParent()
        }
    
        toRemove.insert(entity)
        entities.remove(entity)
    }

//    func update(_ deltaTime: CFTimeInterval) {
//      for componentSystem in componentSystems {
//        componentSystem.update(deltaTime: deltaTime)
//      }
//
//      for currentRemove in toRemove {
//        for componentSystem in componentSystems {
//          componentSystem.removeComponent(foundIn: currentRemove)
//        }
//      }
//      toRemove.removeAll()
//    }

//    func castle(for team: Team) -> GKEntity? {
//      for entity in entities {
//        if let teamComponent = entity.component(ofType: TeamComponent.self),
//          let _ = entity.component(ofType: CastleComponent.self) {
//          if teamComponent.team == team {
//            return entity
//          }
//        }
//      }
//      return nil
//    }

//    func spawnQuirk(team: Team) {
//      guard let teamEntity = castle(for: team),
//        let teamCastleComponent = teamEntity.component(ofType: CastleComponent.self),
//        let teamSpriteComponent = teamEntity.component(ofType: SpriteComponent.self) else {
//          return
//      }
//
//      if teamCastleComponent.coins < costQuirk {
//        return
//      }
//      teamCastleComponent.coins -= costQuirk
//      scene.run(SoundManager.sharedInstance.soundSpawn)
//
//      let monster = Quirk(team: team, entityManager: self)
//      if let spriteComponent = monster.component(ofType: SpriteComponent.self) {
//        spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
//        spriteComponent.node.zPosition = 2
//      }
//      add(monster)
//    }

//    func entities(for team: Team) -> [GKEntity] {
//      return entities.flatMap{ entity in
//        if let teamComponent = entity.component(ofType: TeamComponent.self) {
//          if teamComponent.team == team {
//            return entity
//          }
//        }
//        return nil
//      }
//    }
//
//    func moveComponents(for team: Team) -> [MoveComponent] {
//      let entitiesToMove = entities(for: team)
//      var moveComponents = [MoveComponent]()
//      for entity in entitiesToMove {
//        if let moveComponent = entity.component(ofType: MoveComponent.self) {
//          moveComponents.append(moveComponent)
//        }
//      }
//      return moveComponents
//    }
}
