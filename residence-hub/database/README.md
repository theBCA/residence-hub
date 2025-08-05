# Supabase Database Setup Guide

## 🚀 Quick Setup Steps

### 1. Access Supabase Dashboard
- Go to: https://supabase.com/dashboard/project/vequxwdeoettksvaeybu
- Navigate to: SQL Editor

### 2. Run Database Schema
- Copy the entire contents of `schema.sql`
- Paste into SQL Editor
- Click "Run" to execute

### 3. Configure Authentication Settings

#### Email Configuration
- Go to: Authentication → Providers → Email
- **Enable**: Email provider
- **Disable**: "Confirm email" (for development)
- **Save changes**

#### URL Configuration  
- Go to: Authentication → URL Configuration
- **Site URL**: `https://thebca.github.io`
- **Redirect URLs**: 
  - `https://thebca.github.io/residence-hub/`
  - `http://localhost:3000/` (for development)
- **Save changes**

### 4. Storage Setup (Optional)
- Go to: Storage → Create new bucket
- **Bucket name**: `avatars`
- **Public bucket**: Yes
- **File size limit**: 50MB

## 📊 Database Tables Created

### Core Tables:
- **profiles** - User profile information
- **tickets** - Support ticket management
- **ticket_comments** - Comments on tickets
- **proposals** - Community proposals
- **votes** - Voting records
- **expenses** - Financial expense tracking
- **payments** - Payment records
- **announcements** - Community announcements

### Security Features:
- ✅ **Row Level Security (RLS)** enabled on all tables
- ✅ **Policies** for proper data access control
- ✅ **Automatic profile creation** on user signup
- ✅ **Indexes** for performance optimization

## 🔐 Authentication Flow

### Registration:
1. User signs up → Profile automatically created
2. Email confirmation (if enabled)
3. Profile completion required
4. Access to main app

### Login:
1. Email/password authentication
2. Session management
3. Profile completeness check
4. Navigation to appropriate page

### Password Reset:
1. User requests reset
2. Email sent with reset link
3. GitHub Pages handles reset
4. User can login with new password

## 🧪 Testing Checklist

After setup, test these flows:

### Authentication:
- [ ] User registration
- [ ] User login
- [ ] Password reset
- [ ] Profile completion
- [ ] Logout

### Data Access:
- [ ] Profile creation on signup
- [ ] Profile update
- [ ] Ticket creation
- [ ] Proposal creation
- [ ] Vote submission

### Security:
- [ ] Users can only access their own data
- [ ] Public data is readable by all
- [ ] RLS policies working correctly

## 🚨 Troubleshooting

### Common Issues:

**"Table doesn't exist"**
- Run the schema.sql script again
- Check SQL Editor for errors

**"Policy violation"**
- Verify RLS is enabled
- Check policy definitions
- Ensure user is authenticated

**"Profile not created"**
- Check trigger function exists
- Verify trigger is attached to auth.users

**"Email not sending"**
- Check email provider settings
- Verify SMTP configuration
- Test with valid email address

## 📱 App Configuration

### Update Flutter App:
- Verify Supabase URL and keys in `lib/main.dart`
- Test authentication flows
- Check all repository methods

### Environment Variables:
```dart
// In lib/main.dart
await Supabase.initialize(
  url: 'https://vequxwdeoettksvaeybu.supabase.co',
  anonKey: 'your-anon-key',
);
```

## 🎯 Next Steps

1. **Run the schema** in Supabase SQL Editor
2. **Configure authentication** settings
3. **Test registration** flow in app
4. **Verify profile creation** works
5. **Test all features** systematically

## 📞 Support

If you encounter issues:
1. Check Supabase logs in dashboard
2. Verify SQL script execution
3. Test with simple queries first
4. Check authentication settings 