var crypto = require('crypto');
var expectedAuthHash = ${auth_hash};

function handler(event) {
    var request = event.request;
    // API authentication belongs to the application, including the exact /api path.
    if (request.uri === '/api' || request.uri.startsWith('/api/')) {
        return request;
    }
    if (expectedAuthHash) {
        var authorization = request.headers.authorization;
        var hash = authorization && crypto.createHash('sha256').update(authorization.value).digest('hex');
        if (hash !== expectedAuthHash) {
            return {
                statusCode: 401,
                statusDescription: 'Unauthorized',
                headers: {
                    'www-authenticate': { value: 'Basic realm="Restricted", charset="UTF-8"' },
                    'cache-control': { value: 'no-store' }
                }
            };
        }
        // Keep the edge password out of S3 requests.
        delete request.headers.authorization;
    }
    var uri = request.uri;

    // Preserve static files.
    if (uri.includes('.')) {
        return request;
    }

    request.uri = '/index.html';
    return request;
}
