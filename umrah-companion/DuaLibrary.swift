//
//  DuaLibrary.swift
//  Umrah Companion
//
//  The complete dua library, bundled locally so the app works fully offline.
//

import Foundation

enum DuaLibrary {

    /// Every dua available in the app.
    static let all: [Dua] = [

        // MARK: Tawaf
        Dua(id: "tawaf_start",
            category: .tawaf,
            title: "Starting a Circuit",
            arabic: "بِسْمِ اللَّهِ وَاللَّهُ أَكْبَرُ",
            transliteration: "Bismillāhi wa-llāhu akbar",
            english: "In the name of Allah, and Allah is the Greatest.",
            reference: "Said facing the Black Stone"),

        Dua(id: "tawaf_corners",
            category: .tawaf,
            title: "Between the Two Corners",
            arabic: "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
            transliteration: "Rabbanā ātinā fid-dunyā ḥasanah, wa fil-ākhirati ḥasanah, wa qinā ʿadhāban-nār",
            english: "Our Lord, grant us good in this world and good in the Hereafter, and protect us from the punishment of the Fire.",
            reference: "Qur'an 2:201"),

        // MARK: Sa'i
        Dua(id: "sai_symbols",
            category: .sai,
            title: "Approaching Safa",
            arabic: "إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ",
            transliteration: "Innaṣ-ṣafā wal-marwata min shaʿā'irillāh",
            english: "Indeed, Safa and Marwah are among the symbols of Allah.",
            reference: "Qur'an 2:158"),

        Dua(id: "sai_begin",
            category: .sai,
            title: "Beginning as Allah Began",
            arabic: "أَبْدَأُ بِمَا بَدَأَ اللَّهُ بِهِ",
            transliteration: "Abda'u bimā bada'a-llāhu bih",
            english: "I begin with that which Allah began with.",
            reference: "Reported from the Prophet ﷺ"),

        Dua(id: "sai_summit",
            category: .sai,
            title: "Upon Safa & Marwah",
            arabic: "اللَّهُ أَكْبَرُ، لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
            transliteration: "Allāhu akbar. Lā ilāha illa-llāhu waḥdahu lā sharīka lah, lahul-mulku wa lahul-ḥamd, wa huwa ʿalā kulli shay'in qadīr",
            english: "Allah is the Greatest. There is no god but Allah alone, without partner. His is the dominion and His is all praise, and He has power over all things.",
            reference: "Sahih Muslim"),

        // MARK: Dhikr
        Dua(id: "dhikr_tahlil",
            category: .dhikr,
            title: "Tahlil",
            arabic: "لَا إِلَهَ إِلَّا اللَّهُ",
            transliteration: "Lā ilāha illa-llāh",
            english: "There is no god but Allah.",
            reference: nil),

        Dua(id: "dhikr_tasbih",
            category: .dhikr,
            title: "Tasbih",
            arabic: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
            transliteration: "Subḥāna-llāhi wa biḥamdih",
            english: "Glory be to Allah, and praise be to Him.",
            reference: "Sahih al-Bukhari"),

        Dua(id: "dhikr_takbir",
            category: .dhikr,
            title: "Takbir",
            arabic: "اللَّهُ أَكْبَرُ",
            transliteration: "Allāhu akbar",
            english: "Allah is the Greatest.",
            reference: nil),

        Dua(id: "dhikr_hamd",
            category: .dhikr,
            title: "Tahmid",
            arabic: "الْحَمْدُ لِلَّهِ",
            transliteration: "Al-ḥamdu lillāh",
            english: "All praise is due to Allah.",
            reference: nil),

        Dua(id: "dhikr_istighfar",
            category: .dhikr,
            title: "Istighfar",
            arabic: "أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ",
            transliteration: "Astaghfiru-llāha wa atūbu ilayh",
            english: "I seek the forgiveness of Allah and turn to Him in repentance.",
            reference: nil),

        Dua(id: "dhikr_salawat",
            category: .dhikr,
            title: "Salawat",
            arabic: "اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ",
            transliteration: "Allāhumma ṣalli wa sallim ʿalā nabiyyinā Muḥammad",
            english: "O Allah, send blessings and peace upon our Prophet Muhammad.",
            reference: nil),

        Dua(id: "dhikr_hawqala",
            category: .dhikr,
            title: "Hawqala",
            arabic: "لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ",
            transliteration: "Lā ḥawla wa lā quwwata illā billāh",
            english: "There is no might nor power except with Allah.",
            reference: nil),

        // MARK: Supplications
        Dua(id: "dua_taqabbal",
            category: .supplications,
            title: "Accept From Us",
            arabic: "رَبَّنَا تَقَبَّلْ مِنَّا إِنَّكَ أَنْتَ السَّمِيعُ الْعَلِيمُ",
            transliteration: "Rabbanā taqabbal minnā innaka antas-samīʿul-ʿalīm",
            english: "Our Lord, accept this from us. Indeed, You are the All-Hearing, the All-Knowing.",
            reference: "Qur'an 2:127"),

        Dua(id: "dua_jannah",
            category: .supplications,
            title: "Seeking Paradise",
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ",
            transliteration: "Allāhumma innī as'alukal-jannata wa aʿūdhu bika minan-nār",
            english: "O Allah, I ask You for Paradise and seek refuge in You from the Fire.",
            reference: "Sunan Abi Dawud"),

        Dua(id: "dua_afiyah",
            category: .supplications,
            title: "Pardon & Well-being",
            arabic: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ",
            transliteration: "Allāhumma innī as'alukal-ʿafwa wal-ʿāfiyata fid-dunyā wal-ākhirah",
            english: "O Allah, I ask You for pardon and well-being in this world and the Hereafter.",
            reference: "Sunan Ibn Majah"),

        Dua(id: "dua_forgive",
            category: .supplications,
            title: "Seeking Forgiveness",
            arabic: "رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ",
            transliteration: "Rabbi-ghfir lī wa tub ʿalayya innaka antat-tawwābur-raḥīm",
            english: "My Lord, forgive me and accept my repentance. Indeed, You are the Ever-Relenting, the Most Merciful.",
            reference: nil),

        Dua(id: "dua_thabbit",
            category: .supplications,
            title: "Steadfast Heart",
            arabic: "يَا مُقَلِّبَ الْقُلُوبِ ثَبِّتْ قَلْبِي عَلَى دِينِكَ",
            transliteration: "Yā muqalliba-l-qulūbi thabbit qalbī ʿalā dīnik",
            english: "O Turner of hearts, make my heart firm upon Your religion.",
            reference: "Sunan al-Tirmidhi"),

        Dua(id: "dua_hasbunallah",
            category: .supplications,
            title: "Allah is Sufficient",
            arabic: "حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ",
            transliteration: "Ḥasbuna-llāhu wa niʿmal-wakīl",
            english: "Allah is sufficient for us, and He is the best Disposer of affairs.",
            reference: "Qur'an 3:173"),
    ]

    /// Fast lookup used when resolving a saved queue back into duas.
    static let byID: [String: Dua] = Dictionary(uniqueKeysWithValues: all.map { ($0.id, $0) })

    /// Duas belonging to a category, in library order.
    static func duas(in category: DuaCategory) -> [Dua] {
        all.filter { $0.category == category }
    }
}
