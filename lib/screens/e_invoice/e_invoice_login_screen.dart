import 'dart:math';
import 'package:flutter/material.dart';

// Note: I've wrapped your existing page in a standard Scaffold with an AppBar
// to make it integrate smoothly with the rest of your app's navigation.

class EInvoiceLoginScreen extends StatelessWidget {
  const EInvoiceLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Added a Scaffold to provide a standard app bar with a back button
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Invoice Portal Login'),
      ),
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 800) {
              return _buildDesktopLayout(context);
            } else {
              return _buildMobileLayout(context);
            }
          },
        ),
      ),
    );
  }
  
  Widget _buildDesktopLayout(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: const Row(
            children: [
              Expanded(child: BrandingSide()),
              Expanded(child: LoginSide()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.0),
          child: const Column(
            children: [
              BrandingSide(),
              LoginSide(),
            ],
          ),
        ),
      ),
    );
  }
}

// Left side panel with branding and information
class BrandingSide extends StatelessWidget {
  const BrandingSide({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF2563EB),
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long, color: Colors.white, size: 48),
              SizedBox(width: 16),
              Text(
                'e-Invoice Portal',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Official Government of India portal for e-invoicing under GST.',
            style: TextStyle(color: Colors.blue[100], fontSize: 16),
          ),
          const SizedBox(height: 24),
          const InfoListItem(
            text: 'Secure and authenticated login for taxpayers and GSPs.',
          ),
          const SizedBox(height: 12),
          const InfoListItem(
            text: 'Generate, track, and manage all your e-invoices seamlessly.',
          ),
        ],
      ),
    );
  }
}

class InfoListItem extends StatelessWidget {
  final String text;
  const InfoListItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle, color: Colors.blue[50], size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: Colors.blue[50], fontSize: 15),
          ),
        ),
      ],
    );
  }
}

// Right side panel with the login form
class LoginSide extends StatefulWidget {
  const LoginSide({super.key});

  @override
  State<LoginSide> createState() => _LoginSideState();
}

class _LoginSideState extends State<LoginSide> {
  final _formKey = GlobalKey<FormState>();
  String _captchaText = '';
  final _captchaController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateCaptcha();
  }

  void _generateCaptcha() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    setState(() {
      _captchaText = String.fromCharCodes(Iterable.generate(
          6, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
      _captchaController.clear();
    });
  }
  
  void _login() async {
    FocusScope.of(context).unfocus();
    
    if (_formKey.currentState?.validate() ?? false) {
      if (_captchaController.text.toLowerCase() != _captchaText.toLowerCase()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid captcha. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        _generateCaptcha();
        return;
      }

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 2));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Login successful! Redirecting...'),
          backgroundColor: Colors.green,
        ),
      );
      
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() {
        _isLoading = false;
        _formKey.currentState?.reset();
      });
      _generateCaptcha();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDarkMode ? const Color(0xFF1E293B) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Portal Login',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter your credentials to access your account.',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Username / GSTIN',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your username';
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter your password';
                return null;
              },
            ),
            const SizedBox(height: 20),
            const Text('Enter Captcha', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _captchaText,
                      style: TextStyle(
                        fontFamily: 'Courier',
                        fontSize: 24,
                        letterSpacing: 4,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.grey[500],
                        decorationThickness: 2.0,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: _generateCaptcha,
                  tooltip: 'Refresh Captcha',
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _captchaController,
              decoration: const InputDecoration(
                hintText: 'Enter the text above',
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Please enter the captcha';
                return null;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading 
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
             Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: (){}, child: const Text('Forgot Password?')),
                  const Text('|'),
                  TextButton(onPressed: (){}, child: const Text('New User? Register'))
                ],
            )
          ],
        ),
      ),
    );
  }
}