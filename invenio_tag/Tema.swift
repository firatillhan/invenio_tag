//
//  Tema.swift
//  Invera
//
//  Created by Fırat İlhan on 24.04.2026.
//

import Foundation
import UIKit

// MARK: - Tema
// Uygulamanın tüm renk, font ve ölçü sabitlerinin merkezi.
// Bir yerden değiştirince tüm uygulamada değişir.

enum Tema {
    
    // MARK: - Renkler
    enum Renk {
        // Ana yeşil — bulma/takip hissi
        static let ana = UIColor(red: 26/255, green: 153/255, blue: 86/255, alpha: 1.0)
        
        // Arka plan (off-white, hafif kremsi)
        static let arkaPlan = UIColor(red: 250/255, green: 250/255, blue: 247/255, alpha: 1.0)
        
        // Kart arka planı (beyaz)
        static let kartArkaPlan = UIColor.white
        
        // Kart kenarlığı (çok açık gri)
        static let kenarlik = UIColor(red: 236/255, green: 236/255, blue: 234/255, alpha: 1.0)
        
        // Ayırıcı çizgi (biraz daha koyu)
        static let ayrac = UIColor(red: 208/255, green: 208/255, blue: 202/255, alpha: 1.0)
        
        // Metinler
        static let anaMetin = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1.0)
        static let ikinciMetin = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        static let ucuncuMetin = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
        
        // Tehlike (cihaz silme vb.)
        static let tehlike = UIColor(red: 199/255, green: 44/255, blue: 44/255, alpha: 1.0)
        static let tehlikeKenar = UIColor(red: 240/255, green: 213/255, blue: 213/255, alpha: 1.0)
    }
    
    // MARK: - Fontlar
    enum Font {
        
        // Büyük başlık (Cihazlarım, Anahtarlık gibi)
        static func baslikBuyuk(_ boyut: CGFloat = 34) -> UIFont {
            return .systemFont(ofSize: boyut, weight: .bold)
        }
        
        // Orta başlık (kart başlıkları)
        static func baslikOrta(_ boyut: CGFloat = 22) -> UIFont {
            return .systemFont(ofSize: boyut, weight: .semibold)
        }
        
        // Küçük başlık
        static func baslikKucuk(_ boyut: CGFloat = 17) -> UIFont {
            return .systemFont(ofSize: boyut, weight: .semibold)
        }
        
        // İtalik alt yazı (Fraunces-Italic yerine)
        static func italikAltyazi(_ boyut: CGFloat = 18) -> UIFont {
            return .italicSystemFont(ofSize: boyut)
        }
        
        // Etiket (UPPERCASE teknik etiketler)
        static func etiket(_ boyut: CGFloat = 11) -> UIFont {
            return .monospacedSystemFont(ofSize: boyut, weight: .regular)
        }
        
        // Orta etiket (vurgu için)
        static func etiketOrta(_ boyut: CGFloat = 11) -> UIFont {
            return .monospacedSystemFont(ofSize: boyut, weight: .medium)
        }
        
        // Gövde metni (standart paragraf)
        static func govde(_ boyut: CGFloat = 15) -> UIFont {
            return .systemFont(ofSize: boyut, weight: .regular)
        }
        
        // Gövde orta (vurgu)
        static func govdeOrta(_ boyut: CGFloat = 15) -> UIFont {
            return .systemFont(ofSize: boyut, weight: .medium)
        }
        
        // Gövde kalın (buton metni)
        static func govdeKalin(_ boyut: CGFloat = 15) -> UIFont {
            return .systemFont(ofSize: boyut, weight: .semibold)
        }
        
        // Mesafe gösterimi gibi büyük sayılar
        static func buyukSayi(_ boyut: CGFloat = 28) -> UIFont {
            return .systemFont(ofSize: boyut, weight: .regular)
        }
    }
    
    // MARK: - Ölçüler
    enum Olcu {
        static let kenarBosluk: CGFloat = 24        // ekran kenar padding
        static let kartIcBosluk: CGFloat = 20       // kart içi padding
        static let kartKoseYumusakligi: CGFloat = 20
        static let kucukKoseYumusakligi: CGFloat = 16
        static let buyukButonYuksekligi: CGFloat = 54
        static let cihazHucreYuksekligi: CGFloat = 80
    }
}
