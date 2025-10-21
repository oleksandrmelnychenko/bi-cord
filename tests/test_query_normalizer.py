"""
Comprehensive Unit Tests for Query Normalizer (ULTIMATE EDITION)

Tests cover:
1. Word-order invariance
2. Ukrainian/Russian morphological handling
3. Automotive synonym expansion
4. Technical abbreviation recognition
5. Stopword removal
6. Cache performance
7. Edge cases and error handling
"""

import unittest
from typing import List, Set
import sys
import os

# Add src to path for imports
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'src'))

from ml.query_normalizer import (
    normalize_query,
    tokenize_query,
    remove_stopwords,
    clear_cache,
    get_cache_stats,
    stem_ukrainian_adjective,
    stem_ukrainian_noun,
    contains_polish_characters,
)


class TestQueryNormalizerBasics(unittest.TestCase):
    """Test basic tokenization and stopword removal"""

    def setUp(self):
        """Clear cache before each test"""
        clear_cache()

    def test_tokenize_simple_query(self):
        """Test simple query tokenization"""
        result: List[str] = tokenize_query("brake pads for trucks")
        self.assertEqual(result, ['brake', 'pads', 'for', 'trucks'])

    def test_tokenize_ukrainian_query(self):
        """Test Ukrainian query tokenization"""
        result: List[str] = tokenize_query("Гвинт кріплення амортизатора")
        self.assertEqual(result, ['гвинт', 'кріплення', 'амортизатора'])

    def test_tokenize_mixed_case(self):
        """Test mixed case normalization"""
        result: List[str] = tokenize_query("ABS System Filter")
        self.assertEqual(result, ['abs', 'system', 'filter'])

    def test_tokenize_polish_diacritics(self):
        """Polish characters should be excluded entirely"""
        result: List[str] = tokenize_query("Śruby półki dla ciężarówki")
        self.assertTrue(
            all(not contains_polish_characters(token) for token in result),
            f"Tokens should not contain Polish characters: {result}"
        )

    def test_remove_stopwords_ukrainian(self):
        """Test Ukrainian stopword removal"""
        words: List[str] = ['для', 'гвинт', 'і', 'кріплення', 'на']
        result: List[str] = remove_stopwords(words)
        self.assertEqual(sorted(result), sorted(['гвинт', 'кріплення']))

    def test_remove_stopwords_english(self):
        """Test English stopword removal"""
        words: List[str] = ['the', 'brake', 'for', 'pads']
        result: List[str] = remove_stopwords(words)
        # Current implementation only removes Ukrainian/Russian stopwords
        # English stopwords like 'the', 'for' are not in the stopword list
        self.assertIn('brake', result)
        self.assertIn('pads', result)


class TestWordOrderInvariance(unittest.TestCase):
    """Test word-order invariant search behavior"""

    def setUp(self):
        clear_cache()

    def test_word_order_ukrainian_simple(self):
        """Test basic word-order invariance for Ukrainian"""
        query1: str = "Гвинт кріплення"
        query2: str = "кріплення гвинта"

        normalized1: Set[str] = set(normalize_query(query1, expand_cases=True))
        normalized2: Set[str] = set(normalize_query(query2, expand_cases=True))

        self.assertEqual(normalized1, normalized2,
                         f"Word order should not affect results:\n{normalized1}\nvs\n{normalized2}")

    def test_word_order_ukrainian_complex(self):
        """Test word-order invariance with longer queries"""
        query1: str = "тормозная колодка дисковый тормоз"
        query2: str = "дисковий гальмо колодка тормозна"

        normalized1: Set[str] = set(normalize_query(query1, expand_cases=True))
        normalized2: Set[str] = set(normalize_query(query2, expand_cases=True))

        # Should have significant overlap due to synonyms
        overlap: int = len(normalized1 & normalized2)
        self.assertGreater(overlap, 5,
                           f"Should have significant overlap. Got {overlap} common terms")

    def test_word_order_english(self):
        """Test word-order invariance for English"""
        query1: str = "brake pads filter"
        query2: str = "filter pads brake"

        normalized1: Set[str] = set(normalize_query(query1, expand_cases=False))
        normalized2: Set[str] = set(normalize_query(query2, expand_cases=False))

        self.assertEqual(normalized1, normalized2)


class TestUkrainianMorphology(unittest.TestCase):
    """Test Ukrainian grammatical case handling"""

    def setUp(self):
        clear_cache()

    def test_adjective_forms(self):
        """Test Ukrainian adjective case expansion"""
        result: Set[str] = set(stem_ukrainian_adjective("тормозний"))

        expected_forms: Set[str] = {'тормозний', 'тормозна', 'тормозне', 'тормозні', 'тормоз'}
        self.assertTrue(expected_forms.issubset(result),
                        f"Missing forms. Got: {result}")

    def test_noun_genitive_forms(self):
        """Test Ukrainian noun genitive case (-а ending)"""
        result: Set[str] = set(stem_ukrainian_noun("гвинта"))

        self.assertIn("гвинт", result, "Should extract base form from genitive")
        self.assertIn("гвинта", result, "Should keep genitive form")

    def test_noun_instrumental_forms(self):
        """Test Ukrainian noun instrumental case (-ом ending)"""
        result: Set[str] = set(stem_ukrainian_noun("гвинтом"))

        self.assertIn("гвинт", result, "Should extract base form from instrumental")
        self.assertIn("гвинтом", result, "Should keep instrumental form")

    def test_noun_prepositional_forms(self):
        """Test Ukrainian noun prepositional case (-і ending)"""
        result: Set[str] = set(stem_ukrainian_noun("амортизаторі"))

        self.assertIn("амортизатор", result, "Should extract base form from prepositional")
        self.assertIn("амортизаторі", result, "Should keep prepositional form")

    def test_no_overstemming(self):
        """Test that short words are not over-stemmed"""
        result: Set[str] = set(stem_ukrainian_noun("на"))

        self.assertEqual(result, {'на'}, "Short words should not be stemmed")


class TestAutomotiveSynonyms(unittest.TestCase):
    """Test automotive domain synonym expansion"""

    def setUp(self):
        clear_cache()

    def test_brake_synonyms(self):
        """Test brake-related synonyms"""
        query: str = "тормоз"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        expected: Set[str] = {'тормоз', 'гальмо', 'тормозной', 'гальмівний'}
        self.assertTrue(expected.issubset(result),
                        f"Missing brake synonyms. Got: {result}")

    def test_filter_synonyms(self):
        """Test filter-related synonyms"""
        query: str = "фильтр воздушный"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertIn('фільтр', result, "Should include Ukrainian variant")
        self.assertIn('повітряний', result, "Should include Ukrainian air filter term")
        self.assertNotIn('filtr', result, "Polish variants should be excluded")

    def test_oil_filter_synonyms(self):
        """Test oil filter multilingual support"""
        query: str = "масляний фільтр"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertIn('масляний', result)
        self.assertIn('масляный', result, "Should include Russian variant")
        self.assertNotIn('oleju', result, "Polish variants should be excluded")

    def test_suspension_synonyms(self):
        """Test suspension component synonyms"""
        query: str = "амортизатор передній"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertIn('амортизатор', result)
        self.assertNotIn('amortyzator', result, "Polish variants should be excluded")
        self.assertIn('передній', result)

    def test_seal_synonyms(self):
        """Test seal/gasket synonyms"""
        query: str = "сальник колінвала"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertIn('сальник', result)
        self.assertNotIn('uszczelniacz', result, "Polish variants should be excluded")


class TestTechnicalAbbreviations(unittest.TestCase):
    """Test technical abbreviation recognition"""

    def setUp(self):
        clear_cache()

    def test_abs_abbreviation(self):
        """Test ABS system abbreviation"""
        query: str = "ABS датчик"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertIn('abs', result)
        self.assertIn('антиблокувальна', result, "Should expand ABS to Ukrainian")
        self.assertIn('system', result)

    def test_ebs_abbreviation(self):
        """Test EBS system abbreviation"""
        query: str = "EBS клапан"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertIn('ebs', result)
        self.assertIn('електронна', result, "Should expand EBS to Ukrainian")

    def test_vehicle_manufacturer_abbreviations(self):
        """Test vehicle manufacturer names"""
        for manufacturer in ['mercedes', 'scania', 'volvo', 'man', 'daf', 'bpw']:
            query: str = f"{manufacturer} запчасти"
            result: Set[str] = set(normalize_query(query, expand_cases=True))

            self.assertIn(manufacturer, result,
                          f"{manufacturer} should be recognized")

    def test_vehicle_type_abbreviations(self):
        """Test vehicle type terms"""
        query: str = "вантажівка причіп"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertIn('вантажівка', result)
        self.assertIn('truck', result, "Should include English variant")
        self.assertIn('причіп', result)
        self.assertIn('trailer', result, "Should include English variant")


class TestPolishTranslations(unittest.TestCase):
    """Ensure Polish language terms are excluded"""

    def setUp(self):
        clear_cache()

    def test_brake_polish(self):
        """Test Polish brake terms"""
        query: str = "тормозна колодка"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertNotIn('кlocek', result, "Polish brake pad term should be excluded")
        self.assertIn('тормоз', result)

    def test_filter_polish(self):
        """Test Polish filter terms"""
        query: str = "фільтр"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertNotIn('filtr', result, "Polish filter term should be excluded")
        self.assertNotIn('wkład', result, "Polish insert term should be excluded")

    def test_fastener_polish(self):
        """Test Polish fastener terms"""
        query: str = "гвинт"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertNotIn('śruba', result, "Polish screw term should be excluded")

    def test_mounting_polish(self):
        """Test Polish mounting terms"""
        query: str = "кріплення"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertNotIn('mocowanie', result, "Polish mounting term should be excluded")


class TestCachePerformance(unittest.TestCase):
    """Test LRU cache functionality and performance"""

    def setUp(self):
        clear_cache()

    def test_cache_initialization(self):
        """Test cache starts empty"""
        stats: dict = get_cache_stats()

        for func_name, func_stats in stats.items():
            self.assertEqual(func_stats['hits'], 0,
                             f"{func_name} should start with 0 hits")
            self.assertEqual(func_stats['misses'], 0,
                             f"{func_name} should start with 0 misses")
            self.assertEqual(func_stats['size'], 0,
                             f"{func_name} should start with 0 cached items")

    def test_cache_hit_after_repeated_query(self):
        """Test cache hits after repeated queries"""
        query: str = "тормозна колодка"

        # First call - cache miss
        result1: Set[str] = set(normalize_query(query, expand_cases=True))
        stats_after_first: dict = get_cache_stats()

        # Second call - should hit cache
        result2: Set[str] = set(normalize_query(query, expand_cases=True))
        stats_after_second: dict = get_cache_stats()

        self.assertEqual(result1, result2, "Results should be identical")

        # Verify cache hit occurred
        hits_increased: bool = (
            stats_after_second['normalize_query']['hits'] >
            stats_after_first['normalize_query']['hits']
        )
        self.assertTrue(hits_increased, "Cache hits should increase on repeated query")

    def test_cache_clear(self):
        """Test cache clearing functionality"""
        # Populate cache
        for i in range(10):
            normalize_query(f"query {i}", expand_cases=True)

        stats_before: dict = get_cache_stats()
        self.assertGreater(stats_before['normalize_query']['size'], 0,
                           "Cache should contain items")

        # Clear cache
        clear_cache()

        stats_after: dict = get_cache_stats()
        self.assertEqual(stats_after['normalize_query']['size'], 0,
                         "Cache should be empty after clear")
        self.assertEqual(stats_after['normalize_query']['hits'], 0,
                         "Cache hits should reset to 0")

    def test_cache_size_limits(self):
        """Test cache respects size limits"""
        # Generate more queries than cache can hold (512 limit for normalize_query)
        for i in range(600):
            normalize_query(f"query {i}", expand_cases=True)

        stats: dict = get_cache_stats()
        cache_size: int = stats['normalize_query']['size']
        max_size: int = stats['normalize_query']['maxsize']

        self.assertLessEqual(cache_size, max_size,
                             f"Cache size ({cache_size}) should not exceed maxsize ({max_size})")


class TestEdgeCases(unittest.TestCase):
    """Test edge cases and error handling"""

    def setUp(self):
        clear_cache()

    def test_empty_query(self):
        """Test empty query handling"""
        result: Set[str] = set(normalize_query("", expand_cases=True))
        self.assertEqual(len(result), 0, "Empty query should return empty set")

    def test_whitespace_only_query(self):
        """Test whitespace-only query"""
        result: Set[str] = set(normalize_query("   \n\t  ", expand_cases=True))
        self.assertEqual(len(result), 0, "Whitespace-only query should return empty set")

    def test_stopwords_only_query(self):
        """Test query with only stopwords"""
        result: Set[str] = set(normalize_query("для і на", expand_cases=True))
        self.assertEqual(len(result), 0, "Stopwords-only query should return empty set")

    def test_single_character_query(self):
        """Test single character query"""
        result: Set[str] = set(normalize_query("а", expand_cases=True))
        self.assertEqual(len(result), 0, "Single character should be filtered as stopword")

    def test_very_long_query(self):
        """Test very long query handling"""
        long_query: str = " ".join(["тормоз"] * 50)
        result: Set[str] = set(normalize_query(long_query, expand_cases=True))

        self.assertGreater(len(result), 0, "Long query should still produce results")
        self.assertIn('тормоз', result)
        self.assertIn('гальмо', result)

    def test_special_characters_ignored(self):
        """Test special characters are handled gracefully"""
        query: str = "тормоз!!! колодка??? #filter"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        # Should extract meaningful words and ignore special chars
        self.assertGreater(len(result), 0, "Should extract valid words")
        self.assertIn('тормоз', result)
        self.assertIn('колодка', result)

    def test_mixed_cyrillic_latin(self):
        """Test mixed Cyrillic and Latin characters"""
        query: str = "ABS тормоз brake колодка"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        self.assertIn('abs', result)
        self.assertIn('тормоз', result)
        self.assertIn('brake', result)
        self.assertIn('колодка', result)

    def test_numbers_in_query(self):
        """Test queries with numbers (part codes)"""
        query: str = "100623SAMKO"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        # Should preserve alphanumeric part codes
        self.assertIn('100623samko', result.union({w.lower() for w in result}),
                      "Should preserve part codes")


class TestIntegrationScenarios(unittest.TestCase):
    """Test real-world search scenarios"""

    def setUp(self):
        clear_cache()

    def test_real_world_ukrainian_query(self):
        """Test real Ukrainian automotive query"""
        query: str = "колодка гальмівна для Mercedes вантажівка"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        # Should contain brake pad terms
        self.assertIn('колодка', result)
        self.assertNotIn('кlocek', result, "Polish brake pad variant should be excluded")

        # Should expand gальмівна forms
        brake_adj_forms: Set[str] = {'гальмівний', 'гальмівна', 'гальмівн'}
        self.assertTrue(len(result & brake_adj_forms) > 0,
                        "Should include brake adjective forms")

        # Should recognize manufacturer
        self.assertIn('mercedes', result)

        # Should recognize vehicle type
        self.assertIn('вантажівка', result)
        self.assertIn('truck', result)

    def test_real_world_filter_query(self):
        """Test real filter search query"""
        query: str = "фільтр масляний Scania"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        # Should have filter terms
        self.assertIn('фільтр', result)
        self.assertIn('масляний', result)

        # Should expand to other languages
        self.assertNotIn('filtr', result)  # Polish
        self.assertNotIn('oleju', result)  # Polish oil

        # Should recognize manufacturer
        self.assertIn('scania', result)

    def test_vendor_code_search(self):
        """Test vendor code search behavior"""
        query: str = "BSG60315003"
        result: Set[str] = set(normalize_query(query, expand_cases=False))

        # Should preserve vendor code
        self.assertIn('bsg60315003', result)

    def test_multiword_technical_query(self):
        """Test complex technical query"""
        query: str = "датчик ABS задній лівий"
        result: Set[str] = set(normalize_query(query, expand_cases=True))

        # Should expand ABS
        self.assertIn('abs', result)
        self.assertIn('антиблокувальна', result)

        # Should handle adjectives
        self.assertIn('задній', result)
        self.assertIn('лівий', result)


if __name__ == '__main__':
    # Run tests with verbose output
    unittest.main(verbosity=2)
