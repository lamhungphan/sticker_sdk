# Sticker App Setup Guide

## Environment Configuration

The app requires environment variables to connect to your APIs. Follow these steps to set up:

### 1. Create .env file

Create a `.env` file in the root directory of your project with the following content:

```env
# User API endpoint
USER_URL=https://your-user-api.com/api/users

# Sticker API endpoint  
STICKER_URL=https://your-sticker-api.com/api/stickers

# Remove.bg API token for background removal
REMOVE-BG-TOKEN=your-remove-bg-api-token-here
```

### 2. API Response Format

Your sticker API should return JSON in this format:

```json
[
  {
    "id": "1",
    "category_id": "animals",
    "image_path": "https://example.com/sticker1.png",
    "is_premium": false,
    "status": "active",
    "used_count": 15,
    "tags": ["cat", "animal", "cute"],
    "created_at": "2024-01-15T10:30:00Z"
  }
]
```

### 3. Development Mode

If you don't have a real API yet, the app will automatically use mock data. You'll see debug messages like:
- "Using mock data as fallback"
- "Configuration status: {USER_URL: NOT_SET, STICKER_URL: NOT_SET, ...}"

### 4. Testing the Setup

1. Run the app: `flutter run`
2. Check the console output for configuration status
3. The app should load with either real data or mock data

## Troubleshooting

### "Failed to load all sticker" Error

This error occurs when:
1. The `.env` file is missing
2. The `STICKER_URL` is empty or invalid
3. The API is not responding

**Solutions:**
1. Create the `.env` file with proper URLs
2. Check your API endpoint is accessible
3. Verify the API returns the expected JSON format
4. The app will automatically use mock data as fallback

### Environment Variables Not Loading

If you see "NOT_SET" in the configuration status:
1. Make sure the `.env` file is in the root directory
2. Restart the app after creating the `.env` file
3. Check that the file has no extra spaces or quotes

## Mock Data

The app includes mock data for development with these categories:
- **Animals**: Cat, Dog stickers
- **Emotions**: Happy, Sad stickers  
- **Food**: Pizza, Cake stickers

Each category has both free and premium stickers for testing.

## API Endpoints

### GET /stickers
Returns all stickers grouped by category

### GET /stickers?premium=true  
Returns only premium stickers

### POST /stickers
Upload a new sticker with image file

Required fields:
- `id`: Sticker ID
- `categoryId`: Category ID
- `isPremium`: Boolean
- `status`: String
- `usedCount`: Integer
- `tags`: Comma-separated string
- `createdAt`: ISO 8601 date string
- `image`: Image file 