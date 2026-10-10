function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Preserve API paths and static files.
    if (uri === '/api' || uri.startsWith('/api/') || uri.includes('.')) {
        return request;
    }

    request.uri = '/index.html';
    return request;
}
