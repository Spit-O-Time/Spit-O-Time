//
//  GameOverViewController.swift
//  SpitOTime
//
//  Created by Albert Rayneer on 18/03/21.
//

import UIKit

class GameOverViewController: UIViewController {

    lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .cardBackgroundColor
        view.layer.masksToBounds = false
        view.layer.cornerRadius = 24
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var gameOverLabel: UILabel = {
        let label = UILabel()
        label.text = "Game\nOver"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 50)
        label.textColor = .buttonColor
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var restartButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .buttonColor
        button.layer.masksToBounds = false
        button.layer.cornerRadius = 16
        button.setTitle("Restart", for: .normal)
        button.setTitleColor(.cardBackgroundColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var mainMenuButton: UIButton = {
        let button = UIButton()
        button.setTitle("Main Menu", for: .normal)
        button.setTitleColor(.buttonColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewHierarchy()
        setupConstraints()
    }
    
    private func setupViewHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(gameOverLabel)
        view.addSubview(restartButton)
        view.addSubview(mainMenuButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundView.heightAnchor.constraint(equalToConstant: 420),
            backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            gameOverLabel.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            gameOverLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            gameOverLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            gameOverLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 42),
            
            restartButton.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: 42),
            restartButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            restartButton.heightAnchor.constraint(equalToConstant: 64),
            restartButton.widthAnchor.constraint(equalToConstant: 200),
            
            mainMenuButton.topAnchor.constraint(equalTo: restartButton.bottomAnchor, constant: 24),
            mainMenuButton.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            mainMenuButton.heightAnchor.constraint(equalToConstant: 64),
            mainMenuButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }

}
