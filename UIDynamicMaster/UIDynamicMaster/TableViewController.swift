//
//  TableViewController.swift
//  UIDynamicMaster
//
//  Created by Hank_Zhong on 2019/2/21.
//  Copyright © 2019 Hank_Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var models: [Model] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 50
        tableView.separatorInset = .zero
        
        navigationController?.view.backgroundColor = view.backgroundColor
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        edgesForExtendedLayout = [.top]
//        extendedLayoutIncludesOpaqueBars = true
        
        //hack to navigationController edgePanGesture
        if let target = (navigationController?.interactivePopGestureRecognizer?.value(forKey: "_targets") as? [AnyObject])?.first,
            let _target = target.value(forKey: "_target"),
            (_target as AnyObject).responds(to: Selector(("handleNavigationTransition:"))) {
            let naviPan = UIPanGestureRecognizer(target: _target, action: Selector(("handleNavigationTransition:")))
            naviPan.delegate = self
            navigationController?.navigationBar.addGestureRecognizer(naviPan)
            
            let toolPan = UIPanGestureRecognizer(target: _target, action: Selector(("handleNavigationTransition:")))
            toolPan.delegate = self
            navigationController?.toolbar.addGestureRecognizer(toolPan)
            
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        
        models.append(.init(title: "Gravity", controller: {
            let lazyGravity = UIGravityBehavior.lazy {
                let gravity = UIGravityBehavior()
                gravity.gravityDirection = CGVector(dx: 0.1, dy: 1.0)
                return gravity
            }
            return GravityDynamicViewController(preferScenario: .touch_then_drop(gravity: lazyGravity))
        }))
        
        models.append(.init(title: "Gravity and Collision", controller: {
            let lazyGravity = UIGravityBehavior.lazy {
                let gravity = UIGravityBehavior()
                gravity.magnitude = 5
                return gravity
            }
            let lazyCollision = UICollisionBehavior.lazy { return UICollisionBehavior() }
            return GravityDynamicViewController(preferScenario: .touch_then_drop_and_collision(gravity: lazyGravity, collision: lazyCollision))
        }))
        
        models.append(.init(title: "Gravity and Collision with barrier", controller: {
            let lazyGravity = UIGravityBehavior.lazy {
                let gravity = UIGravityBehavior()
                gravity.magnitude = 0.5
                return gravity
            }
            let lazyCollision = UICollisionBehavior.lazy { return UICollisionBehavior() }
            return GravityDynamicViewController(preferScenario: .touch_then_drop_and_collision_withBarrier(gravity: lazyGravity, collision: lazyCollision, barrierSize: CGSize(width: 150, height: 30)))
        }))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setToolbarHidden(true, animated: true)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = models[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        UIView.animate(withDuration: 0.2, animations: {
            tableView.deselectRow(at: indexPath, animated: true)
        }) { (_) in
            let vc = model.controller()
            vc.title = model.title
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let controllers = navigationController?.viewControllers, controllers.count != 1 else {
            return false
        }
        guard let isTransitioning = (navigationController?.value(forKey: "_isTransitioning") as? Bool), !isTransitioning else {
            return false
        }
        return true
    }
}

struct Model {
    var title: String
    var controller: (() -> (MyViewController))
}

class MyViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
        
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(false, animated: true)
    }
}

