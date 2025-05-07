import redis
import sys
import traceback

#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
RedisLibrary - A Robot Framework library for Redis operations
"""

class RedisLibrary:
    """
    RedisLibrary is a Robot Framework library for Redis operations.
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
        self.redis_client = None
        print(f"Initializing RedisLibrary with {host}:{port}/{db}")
        self.connect_to_redis(host, port, db, password)
    
    def connect_to_redis(self, host, port, db, password=None):
        """
        Connect to Redis with specified parameters
        
        Arguments:
        - host: Redis host
        - port: Redis port
        - db: Redis database
        - password: Redis password (optional)
        """
        try:
            print(f"Connecting to Redis at {host}:{port}/{db}")
            self.redis_client = redis.Redis(
                host=host,
                port=int(port),
                db=int(db),
                password=password,
                decode_responses=True
            )
            # Test connection
            pong = self.redis_client.ping()
            print(f"Redis connection successful: {pong}")
            return True
        except Exception as e:
            print(f"Error connecting to Redis: {e}")
            traceback.print_exc(file=sys.stdout)
            return False
        
    def create_key(self, key, value, ex=None):
        """
        Create a key in Redis cache
        
        Arguments:
        - key: Redis key
        - value: Value to store
        - ex: Expiration time in seconds (optional)
        """
        try:
            print(f"Creating Redis key: {key} = {value}, expires in {ex}s")
            return self.redis_client.set(key, value, ex=ex)
        except Exception as e:
            print(f"Error creating key in Redis: {e}")
            traceback.print_exc(file=sys.stdout)
            return False
        
    def read_key(self, key):
        """
        Read a key from Redis cache
        
        Arguments:
        - key: Redis key
        
        Returns:
        - Value of the key or None if key not found
        """
        try:
            print(f"Reading Redis key: {key}")
            return self.redis_client.get(key)
        except Exception as e:
            print(f"Error reading key from Redis: {e}")
            traceback.print_exc(file=sys.stdout)
            return None
        
    def update_key(self, key, value, ex=None):
        """
        Update a key in Redis cache
        
        Arguments:
        - key: Redis key
        - value: New value
        - ex: Expiration time in seconds (optional)
        """
        return self.create_key(key, value, ex)
        
    def delete_key(self, key):
        """
        Delete a key from Redis cache
        
        Arguments:
        - key: Redis key
        """
        try:
            print(f"Deleting Redis key: {key}")
            return self.redis_client.delete(key) > 0
        except Exception as e:
            print(f"Error deleting key from Redis: {e}")
            traceback.print_exc(file=sys.stdout)
            return False
        
    def key_should_exist(self, key):
        """
        Assert that a key exists in Redis cache
        
        Arguments:
        - key: Redis key
        """
        try:
            print(f"Checking if Redis key exists: {key}")
            if not self.redis_client.exists(key):
                raise AssertionError(f"Key '{key}' does not exist in Redis")
            return True
        except Exception as e:
            print(f"Error checking key existence in Redis: {e}")
            traceback.print_exc(file=sys.stdout)
            raise
        
    def key_should_not_exist(self, key):
        """
        Assert that a key does not exist in Redis cache
        
        Arguments:
        - key: Redis key
        """
        try:
            print(f"Checking if Redis key does not exist: {key}")
            if self.redis_client.exists(key):
                raise AssertionError(f"Key '{key}' exists in Redis")
            return True
        except Exception as e:
            print(f"Error checking key non-existence in Redis: {e}")
            traceback.print_exc(file=sys.stdout)
            raise