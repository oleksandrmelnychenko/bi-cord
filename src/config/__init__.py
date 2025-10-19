"""
Configuration Module

Centralized configuration management using environment variables.
All modules should import from this module instead of hardcoding values.
"""

from src.config.settings import Settings, get_settings

__all__ = ['Settings', 'get_settings']
