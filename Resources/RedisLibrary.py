import redis

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
RedisLibrary - A Robot Framework library for Redis operations
"""

# Mock implementation that doesn't require 'redis' module
class RedisLibrary:
    """
    RedisLibrary is a Robot Framework library for Redis operations.
    
    In testing environment, this mock version simulates Redis operations.
    """
    
    ROBOT_LIBRARY_SCOPE = 'GLOBAL'
    ROBOT_LIBRARY_VERSION = '1.0.0'
    
    def __init__(self, host='localhost', port=6379, db=0, password=None):
        """
        Initialize RedisLibrary with connection parameters
        """
        self.host = host
        self.port = port
        self.db = db
        self.password = password
        self.redis_cache = {}
        print(f"Mock Redis connected to {host}:{port}/{db}")
        
    def create_key(self, key, value, ex=None):
        """
        Create a key in Redis cache
        
        Arguments:
        - key: Redis key
        - value: Value to store
        - ex: Expiration time in seconds (optional)
        """
        self.redis_cache[key] = value
        print(f"Mock Redis: Created key '{key}' with value '{value}'")
        return True
        
    def read_key(self, key):
        """
        Read a key from Redis cache
        
        Arguments:
        - key: Redis key
        
        Returns:
        - Value of the key or None if key not found
        """
        return self.redis_cache.get(key)
        
    def update_key(self, key, value, ex=None):
        """
        Update a key in Redis cache
        
        Arguments:
        - key: Redis key
        - value: New value
        - ex: Expiration time in seconds (optional)
        """
        self.redis_cache[key] = value
        return True
        
    def delete_key(self, key):
        """
        Delete a key from Redis cache
        
        Arguments:
        - key: Redis key
        """
        if key in self.redis_cache:
            del self.redis_cache[key]
        return True
        
    def key_should_exist(self, key):
        """
        Assert that a key exists in Redis cache
        
        Arguments:
        - key: Redis key
        """
        if key not in self.redis_cache:
            raise AssertionError(f"Key '{key}' does not exist in Redis")
        return True
        
    def key_should_not_exist(self, key):
        """
        Assert that a key does not exist in Redis cache
        
        Arguments:
        - key: Redis key
        """
        if key in self.redis_cache:
            raise AssertionError(f"Key '{key}' exists in Redis")
        return True