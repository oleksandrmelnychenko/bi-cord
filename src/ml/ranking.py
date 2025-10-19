"""
ML-Based Multi-Model Ranking System

Combines multiple search signals into a unified ranking score:
1. Exact Match Score (vendor code, name matching)
2. Semantic Similarity Score (vector cosine similarity)
3. Full-Text Search Rank (PostgreSQL ts_rank)
4. Trigram Similarity (fuzzy matching)
5. Popularity Score (clicks, views, sales)
6. Freshness Score (newer products)
7. Availability Score (in stock, for sale, has image)

This ensemble approach mimics Amazon/Google's multi-signal ranking.
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Dict, List, Optional
import math


@dataclass
class SearchSignals:
    """Container for all search scoring signals"""
    product_id: int

    # Text matching signals
    exact_match_score: float = 0.0  # 0-1: Vendor code/name exact match
    fulltext_rank: float = 0.0      # 0-1: PostgreSQL ts_rank normalized
    trigram_similarity: float = 0.0  # 0-1: Fuzzy string match

    # Semantic signals
    vector_similarity: float = 0.0   # 0-1: Cosine similarity

    # Popularity signals
    click_count: int = 0
    view_count: int = 0
    conversion_count: int = 0

    # Product quality signals
    has_image: bool = False
    is_for_sale: bool = False
    is_for_web: bool = False
    weight: float = 0.0  # Physical weight

    # Metadata
    created_at: Optional[str] = None
    updated_at: Optional[str] = None


@dataclass
class RankingWeights:
    """Configurable weights for ensemble ranking"""

    # Text matching weights (sum = 0.45)
    exact_match: float = 0.30      # Highest priority
    fulltext: float = 0.10
    trigram: float = 0.05

    # Semantic weight
    vector_similarity: float = 0.25  # Medium priority

    # Popularity weight
    popularity: float = 0.15        # Medium-low priority

    # Quality signals weight
    availability: float = 0.10      # Low priority
    freshness: float = 0.05         # Lowest priority

    def normalize(self) -> RankingWeights:
        """Ensure weights sum to 1.0"""
        total: float = (
            self.exact_match +
            self.fulltext +
            self.trigram +
            self.vector_similarity +
            self.popularity +
            self.availability +
            self.freshness
        )
        if total == 0:
            return self

        return RankingWeights(
            exact_match=self.exact_match / total,
            fulltext=self.fulltext / total,
            trigram=self.trigram / total,
            vector_similarity=self.vector_similarity / total,
            popularity=self.popularity / total,
            availability=self.availability / total,
            freshness=self.freshness / total,
        )


class EnsembleRanker:
    """
    Multi-model ensemble ranker combining all search signals

    Usage:
        ranker = EnsembleRanker()
        signals = SearchSignals(product_id=123, exact_match_score=1.0, vector_similarity=0.85)
        final_score = ranker.rank(signals)
    """

    def __init__(self, weights: Optional[RankingWeights] = None):
        self.weights: RankingWeights = (weights or RankingWeights()).normalize()

    def rank(self, signals: SearchSignals) -> float:
        """
        Calculate final ensemble ranking score (0-1)

        Higher score = better match
        """
        text_score: float = self._calculate_text_score(signals)
        semantic_score: float = signals.vector_similarity
        popularity_score: float = self._calculate_popularity_score(signals)
        availability_score: float = self._calculate_availability_score(signals)
        freshness_score: float = self._calculate_freshness_score(signals)

        final_score: float = (
            self.weights.exact_match * signals.exact_match_score +
            self.weights.fulltext * signals.fulltext_rank +
            self.weights.trigram * signals.trigram_similarity +
            self.weights.vector_similarity * semantic_score +
            self.weights.popularity * popularity_score +
            self.weights.availability * availability_score +
            self.weights.freshness * freshness_score
        )

        return min(1.0, max(0.0, final_score))  # Clamp to [0, 1]

    def _calculate_text_score(self, signals: SearchSignals) -> float:
        """Combined text matching score"""
        return max(
            signals.exact_match_score,
            signals.fulltext_rank,
            signals.trigram_similarity
        )

    def _calculate_popularity_score(self, signals: SearchSignals) -> float:
        """
        Normalize popularity using log scale to prevent outliers from dominating

        Formula: log(1 + clicks * 3 + views + conversions * 10) / log(1000)
        """
        if signals.click_count == 0 and signals.view_count == 0 and signals.conversion_count == 0:
            return 0.0

        # Weight conversions > clicks > views
        weighted_popularity: float = (
            signals.conversion_count * 10 +
            signals.click_count * 3 +
            signals.view_count
        )

        # Log normalization (prevents popular products from completely dominating)
        normalized: float = math.log(1 + weighted_popularity) / math.log(1000)
        return min(1.0, normalized)

    def _calculate_availability_score(self, signals: SearchSignals) -> float:
        """
        Score based on product availability and quality

        - Has image: +0.3
        - For sale: +0.4
        - For web: +0.3
        """
        score: float = 0.0
        if signals.has_image:
            score += 0.3
        if signals.is_for_sale:
            score += 0.4
        if signals.is_for_web:
            score += 0.3
        return score

    def _calculate_freshness_score(self, signals: SearchSignals) -> float:
        """
        Score based on product age

        For now, returns 0.5 (neutral) - can be enhanced with timestamp comparison
        """
        # TODO: Compare created_at/updated_at to current time
        # Newer products get higher scores (0.7-1.0)
        # Older products get lower scores (0.3-0.5)
        return 0.5  # Neutral score


def rank_search_results(
    results: List[Dict],
    weights: Optional[RankingWeights] = None
) -> List[Dict]:
    """
    Convenience function to rank a list of search results

    Args:
        results: List of dicts with search signal fields
        weights: Optional custom ranking weights

    Returns:
        Sorted list of results with 'ranking_score' field added
    """
    ranker: EnsembleRanker = EnsembleRanker(weights)

    for result in results:
        signals: SearchSignals = SearchSignals(
            product_id=result.get('product_id', 0),
            exact_match_score=result.get('exact_match_score', 0.0),
            fulltext_rank=result.get('fulltext_rank', 0.0),
            trigram_similarity=result.get('trigram_similarity', 0.0),
            vector_similarity=result.get('similarity_score', 0.0),  # From semantic search
            click_count=result.get('click_count', 0),
            view_count=result.get('view_count', 0),
            conversion_count=result.get('conversion_count', 0),
            has_image=result.get('has_image', False),
            is_for_sale=result.get('is_for_sale', False),
            is_for_web=result.get('is_for_web', False),
            weight=result.get('weight', 0.0),
            created_at=result.get('created_at'),
            updated_at=result.get('updated_at'),
        )
        result['ranking_score'] = ranker.rank(signals)

    # Sort by ranking score (descending)
    results.sort(key=lambda x: x.get('ranking_score', 0.0), reverse=True)

    return results


# Preset weight configurations for different use cases
WEIGHT_PRESETS: Dict[str, RankingWeights] = {
    'balanced': RankingWeights(),  # Default balanced weights

    'exact_priority': RankingWeights(
        exact_match=0.50,
        fulltext=0.15,
        trigram=0.05,
        vector_similarity=0.15,
        popularity=0.10,
        availability=0.03,
        freshness=0.02,
    ),

    'semantic_priority': RankingWeights(
        exact_match=0.15,
        fulltext=0.10,
        trigram=0.05,
        vector_similarity=0.45,
        popularity=0.15,
        availability=0.05,
        freshness=0.05,
    ),

    'popularity_priority': RankingWeights(
        exact_match=0.20,
        fulltext=0.10,
        trigram=0.05,
        vector_similarity=0.20,
        popularity=0.35,
        availability=0.05,
        freshness=0.05,
    ),
}
