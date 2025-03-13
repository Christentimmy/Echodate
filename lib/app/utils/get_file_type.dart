


String getMimeType(String filePath) {
  if (filePath.endsWith('.mp4')) return 'video/mp4';
  if (filePath.endsWith('.mov')) return 'video/quicktime';
  if (filePath.endsWith('.jpg') || filePath.endsWith('.jpeg')) return 'image/jpeg';
  if (filePath.endsWith('.png')) return 'image/png';
  return 'application/octet-stream';
}
