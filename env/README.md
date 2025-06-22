Create the following files in this directory:

1. `.env.dev.json`
2. `.env.test.json`
3. `.env.staging.json`
4. `.env.prod.json`

These files should contain the environment variables for each environment. The files should be in
the following format:

```json
{
  "API_BASE_URL": "https://yts.mx/api/v2"
}
```

### Encrypt the new environment files
1. Open Android Studio.
2. Run the ‘encrypt-env’
3. run configuration.