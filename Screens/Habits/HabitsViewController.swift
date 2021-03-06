//
//  HabitsViewController.swift
//  MyHabits
//
//  Created by Даниил Сокол on 08.04.2022.
//

import UIKit

final class HabitsViewController: UIViewController {
    
    //MARK: - Static
    
    static let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInsetReference = .fromContentInset
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return layout
    }()
    
    //collectionView храниться в глобальная память - удалять контроллер
    static let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.97, alpha: 1.00)
        return collectionView
    }()
    
    
    //MARK: - Lifecycle
    
    //загружена рутовая View, но еще не загружена верстка
    override func viewDidLoad() {
        super.viewDidLoad()
        HabitsViewController.collectionView.dataSource = self
        HabitsViewController.collectionView.delegate = self
        view.addSubview(HabitsViewController.collectionView)
        
        HabitsViewController.collectionView.register(ProgressViewCollectionCell.self, forCellWithReuseIdentifier: "habitProgress")
        HabitsViewController.collectionView.register(HabitCollectionCell.self, forCellWithReuseIdentifier: "habitViewCell")
        
        view.backgroundColor = .systemGray5
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addHabitBarButtonAction))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 161/255, green: 22/255, blue: 204/255, alpha: 1.0)
        
        //title = "Привычки"
        //tabBarItem.title = "Привычки"
        
        setupCollectionViewConstrainsts()
    }
    
    //Загружена позиционирование элементы (элементы имеют размеры) но не показана
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Сегодня"
        tabBarController?.tabBar.backgroundColor = .white
    }
    
    //MARK: - Constraints
    
    func setupCollectionViewConstrainsts() {
        NSLayoutConstraint.activate([
            HabitsViewController.collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            HabitsViewController.collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            HabitsViewController.collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            HabitsViewController.collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - Actions
    
    @objc func addHabitBarButtonAction() {
        self.navigationController?.pushViewController(HabitViewController(nil), animated: false)
        HabitsViewController().navigationItem.title = "Создать"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func openHabitCellAction(_ habit: Habit) {
        navigationController?.pushViewController(HabitDetailsViewController(habit), animated: false)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

//MARK: - UICollectionViewDataSource
//MARK: - UICollectionViewDelegateFlowLayout
extension HabitsViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return HabitsStore.shared.habits.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitProgress", for: indexPath) as? ProgressViewCollectionCell else { return UICollectionViewCell() }
            cell.initialProgress()
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "habitViewCell", for: indexPath) as? HabitCollectionCell else { return UICollectionViewCell() }
            cell.configure(habit: HabitsStore.shared.habits[indexPath.item - 1])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.frame.width - (16 * 2), height: 60)
        } else {
            return CGSize(width: collectionView.frame.width - (16 * 2), height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !(indexPath.item == 0) {
            guard let item = collectionView.cellForItem(at: indexPath) as? HabitCollectionCell else { return }
            if let habit = item.habit {
                openHabitCellAction(habit)
            }
        }
    }
    
}
