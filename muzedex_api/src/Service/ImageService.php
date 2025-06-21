<?php

namespace App\Service;

use Symfony\Contracts\HttpClient\HttpClientInterface;
use Aws\S3\S3Client;
use Symfony\Component\Filesystem\Filesystem;
use Liip\ImagineBundle\Imagine\Filter\FilterManager;
use Liip\ImagineBundle\Imagine\Data\DataManager;
use Liip\ImagineBundle\Model\Binary;

class ImageService
{
    private HttpClientInterface $httpClient;
    private S3Client $s3Client;
    private string $minioBucket;
    private FilterManager $filterManager;
    private DataManager $dataManager;

    public function __construct(HttpClientInterface $httpClient, S3Client $s3Client, string $minioBucket, FilterManager $filterManager, DataManager $dataManager)
    {
        $this->httpClient = $httpClient;
        $this->s3Client = $s3Client;
        $this->minioBucket = $_ENV['MINIO_BUCKET'];
        $this->filterManager = $filterManager;
        $this->dataManager = $dataManager;
    }

    public function processImage(string $imageUrl): string
    {
        $tempDir = sys_get_temp_dir() . '/' . uniqid('image_temp_', true);
        $filesystem = new Filesystem();
        $filesystem->mkdir($tempDir);

        try {
            $response = $this->httpClient->request('GET', $imageUrl);
            if ($response->getStatusCode() !== 200) {
                throw new \RuntimeException('Failed to download image: ' . $imageUrl);
            }
            $imageData = $response->getContent();

            $pathInfo = pathinfo(parse_url($imageUrl, PHP_URL_PATH));
            $fileName = $pathInfo['filename'] ?? uniqid('image_', true);

            $tempImage = $tempDir . '/' . $fileName . '.png';
            file_put_contents($tempImage, $imageData);

            $image = new Binary($imageData, 'image/png', 'png');

            $filteredImage = $this->filterManager->applyFilter($image, 'webp_filter');
            $tempWebp = $tempDir . '/' . $fileName . '.webp';
            file_put_contents($tempWebp, $filteredImage->getContent());

            $filesystem->remove($tempImage);

            $this->pushToMinio($tempWebp);

            $publicUrl = rtrim($_ENV['MINIO_ENDPOINT'], '/') . '/' . $this->minioBucket . '/images/' . basename($tempWebp);

            return $publicUrl;
        } finally {
            $filesystem->remove($tempDir);
        }
    }

    private function pushToMinio(string $filePath): void
    {
        try {
            $this->s3Client->putObject([
                'Bucket' => $this->minioBucket,
                'Key' => 'images/' . basename($filePath),
                'Body' => fopen($filePath, 'rb'),
                'ACL' => 'public-read',
                'ContentType' => 'image/webp',
            ]);
        } catch (\Exception $e) {
            throw new \RuntimeException('Error uploading to MinIO: ' . $e->getMessage());
        }
    }
}
