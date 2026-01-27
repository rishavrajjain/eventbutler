// /**
//  * Transcription Service using Supadata API
//  * Handles video transcription for Instagram, YouTube, and TikTok
//  * with retry logic and graceful error handling
//  */

// interface TranscriptSegment {
//   text: string;
//   offset: number;
//   duration: number;
//   lang?: string;
// }

// interface TranscriptResult {
//   transcript: string | null;
//   segments: TranscriptSegment[] | null;
//   lang: string | null;
//   error?: string;
//   source: "supadata" | "fallback" | "none";
// }

// interface SupadataResponse {
//   content: string | TranscriptSegment[];
//   lang?: string;
//   availableLangs?: string[];
// }

// interface SupadataJobResponse {
//   jobId: string;
//   status: "processing" | "completed" | "failed";
//   result?: SupadataResponse;
//   error?: string;
// }

// export interface SupadataMetadata {
//   platform: string;
//   type: string;
//   id: string;
//   url: string;
//   title?: string;
//   description?: string;
//   author?: {
//     username: string;
//     displayName: string;
//     avatarUrl?: string;
//     verified?: boolean;
//   };
//   thumbnailUrl?: string;
//   media?: {
//     type?: string;
//     duration?: number;
//     thumbnailUrl?: string;
//   };
// }

// const SUPADATA_BASE_URL = "https://api.supadata.ai/v1";
// const MAX_RETRIES = 3;
// const RETRY_DELAYS = [1000, 2000, 4000]; // ms
// const REQUEST_TIMEOUT = 60000; // 60 seconds for transcription

// /**
//  * Sleep utility for retry delays
//  */
// function sleep(ms: number): Promise<void> {
//   return new Promise((resolve) => setTimeout(resolve, ms));
// }

// /**
//  * Check if error is retryable (rate limit or temporary)
//  */
// function isRetryableError(status: number): boolean {
//   return status === 429 || status === 503 || status === 502;
// }

// /**
//  * Get transcript from Supadata API
//  */
// export async function getVideoTranscript(url: string): Promise<TranscriptResult> {
//   const apiKey = process.env.SUPADATA_API_KEY;

//   if (!apiKey) {
//     console.log("SUPADATA_API_KEY not configured, skipping transcription");
//     return {
//       transcript: null,
//       segments: null,
//       lang: null,
//       error: "API key not configured",
//       source: "none",
//     };
//   }

//   // Determine mode based on platform
//   const isInstagram = url.includes('instagram.com');
//   const mode = isInstagram ? 'generate' : 'auto';
//   console.log(`[Supadata] Requesting transcript for: ${url} (mode: ${mode})`);

//   let lastError: string | undefined;

//   for (let attempt = 0; attempt < MAX_RETRIES; attempt++) {
//     try {
//       const controller = new AbortController();
//       const timeout = setTimeout(() => controller.abort(), REQUEST_TIMEOUT);

//       const response = await fetch(`${SUPADATA_BASE_URL}/transcript`, {
//         method: "GET",
//         headers: {
//           "x-api-key": apiKey,
//           "Content-Type": "application/json",
//         },
//         signal: controller.signal,
//         // Pass URL as query parameter
//       }).catch(() => null);

//       clearTimeout(timeout);

//       // Use GET with query params as per Supadata docs
//       // mode is determined at the top based on platform (generate for Instagram, auto for YouTube)
//       const transcriptUrl = `${SUPADATA_BASE_URL}/transcript?url=${encodeURIComponent(url)}&text=true&mode=${mode}`;

//       const transcriptResponse = await fetch(transcriptUrl, {
//         method: "GET",
//         headers: {
//           "x-api-key": apiKey,
//         },
//         signal: controller.signal,
//       });

//       clearTimeout(timeout);

//       // Handle async job (202 response)
//       if (transcriptResponse.status === 202) {
//         const jobData: SupadataJobResponse = await transcriptResponse.json();
//         console.log(`[Supadata] Job created: ${jobData.jobId}, polling for result...`);

//         // Poll for job completion
//         const result = await pollForJobCompletion(jobData.jobId, apiKey);
//         if (result) {
//           return result;
//         }
//         lastError = "Job timed out";
//         continue;
//       }

//       // Handle immediate success (200 response)
//       if (transcriptResponse.ok) {
//         const data: SupadataResponse = await transcriptResponse.json();
//         console.log(`[Supadata] Transcript received, lang: ${data.lang}`);

//         // Handle text response (when text=true)
//         if (typeof data.content === "string") {
//           return {
//             transcript: data.content,
//             segments: null,
//             lang: data.lang || "en",
//             source: "supadata",
//           };
//         }

//         // Handle segmented response
//         if (Array.isArray(data.content)) {
//           const fullText = data.content.map((seg) => seg.text).join(" ");
//           return {
//             transcript: fullText,
//             segments: data.content,
//             lang: data.lang || "en",
//             source: "supadata",
//           };
//         }

//         return {
//           transcript: null,
//           segments: null,
//           lang: null,
//           error: "Unexpected response format",
//           source: "none",
//         };
//       }

//       // Handle errors
//       const errorStatus = transcriptResponse.status;
//       const errorBody = await transcriptResponse.text().catch(() => "");

//       console.log(`[Supadata] Error ${errorStatus}: ${errorBody}`);

//       if (isRetryableError(errorStatus) && attempt < MAX_RETRIES - 1) {
//         console.log(`[Supadata] Retrying in ${RETRY_DELAYS[attempt]}ms...`);
//         await sleep(RETRY_DELAYS[attempt]);
//         continue;
//       }

//       // Non-retryable error
//       if (errorStatus === 401) {
//         lastError = "Invalid API key";
//       } else if (errorStatus === 400) {
//         lastError = "Invalid URL or unsupported platform";
//       } else if (errorStatus === 404) {
//         lastError = "Video not found or is private";
//       } else {
//         lastError = `API error: ${errorStatus}`;
//       }
//       break;
//     } catch (error) {
//       if (error instanceof Error && error.name === "AbortError") {
//         lastError = "Request timed out";
//       } else {
//         lastError = error instanceof Error ? error.message : "Unknown error";
//       }
//       console.log(`[Supadata] Attempt ${attempt + 1} failed: ${lastError}`);

//       if (attempt < MAX_RETRIES - 1) {
//         await sleep(RETRY_DELAYS[attempt]);
//       }
//     }
//   }

//   return {
//     transcript: null,
//     segments: null,
//     lang: null,
//     error: lastError,
//     source: "none",
//   };
// }

// /**
//  * Get video metadata from Supadata API
//  * Returns structured author info (username, displayName) for Instagram, YouTube, TikTok
//  */
// export async function getVideoMetadata(url: string): Promise<SupadataMetadata | null> {
//   const apiKey = process.env.SUPADATA_API_KEY;

//   if (!apiKey) {
//     console.log("[Supadata] API key not configured, skipping metadata fetch");
//     return null;
//   }

//   console.log(`[Supadata] Fetching metadata for: ${url}`);

//   try {
//     const response = await fetch(
//       `${SUPADATA_BASE_URL}/metadata?url=${encodeURIComponent(url)}`,
//       {
//         method: "GET",
//         headers: {
//           "x-api-key": apiKey,
//         },
//       }
//     );

//     if (!response.ok) {
//       console.log(`[Supadata] Metadata request failed: ${response.status}`);
//       return null;
//     }

//     const data: SupadataMetadata = await response.json();
//     console.log(`[Supadata] Metadata received - author: ${data.author?.username || "N/A"}`);
//     return data;
//   } catch (error) {
//     console.log(`[Supadata] Metadata fetch error: ${error}`);
//     return null;
//   }
// }

// /**
//  * Poll for async job completion
//  */
// async function pollForJobCompletion(
//   jobId: string,
//   apiKey: string,
//   maxWaitMs: number = 120000 // 2 minutes max
// ): Promise<TranscriptResult | null> {
//   const startTime = Date.now();
//   const pollInterval = 3000; // 3 seconds

//   while (Date.now() - startTime < maxWaitMs) {
//     try {
//       const response = await fetch(`${SUPADATA_BASE_URL}/transcript/${jobId}`, {
//         method: "GET",
//         headers: {
//           "x-api-key": apiKey,
//         },
//       });

//       if (!response.ok) {
//         console.log(`[Supadata] Job poll error: ${response.status}`);
//         await sleep(pollInterval);
//         continue;
//       }

//       const data: SupadataJobResponse = await response.json();

//       if (data.status === "completed" && data.result) {
//         console.log(`[Supadata] Job completed successfully`);

//         if (typeof data.result.content === "string") {
//           return {
//             transcript: data.result.content,
//             segments: null,
//             lang: data.result.lang || "en",
//             source: "supadata",
//           };
//         }

//         if (Array.isArray(data.result.content)) {
//           const fullText = data.result.content.map((seg) => seg.text).join(" ");
//           return {
//             transcript: fullText,
//             segments: data.result.content,
//             lang: data.result.lang || "en",
//             source: "supadata",
//           };
//         }
//       }

//       if (data.status === "failed") {
//         console.log(`[Supadata] Job failed: ${data.error}`);
//         return null;
//       }

//       // Still processing, wait and poll again
//       await sleep(pollInterval);
//     } catch (error) {
//       console.log(`[Supadata] Poll error: ${error}`);
//       await sleep(pollInterval);
//     }
//   }

//   console.log(`[Supadata] Job polling timed out after ${maxWaitMs}ms`);
//   return null;
// }

// /**
//  * Check if URL is supported by Supadata
//  */
// export function isSupportedPlatform(url: string): boolean {
//   try {
//     const parsed = new URL(url);
//     const hostname = parsed.hostname.toLowerCase();

//     return (
//       hostname.includes("instagram.com") ||
//       hostname.includes("youtube.com") ||
//       hostname.includes("youtu.be") ||
//       hostname.includes("tiktok.com") ||
//       hostname.includes("twitter.com") ||
//       hostname.includes("x.com") ||
//       hostname.includes("facebook.com")
//     );
//   } catch {
//     return false;
//   }
// }

// /**
//  * Detect platform from URL
//  */
// export function detectPlatform(url: string): string {
//   try {
//     const parsed = new URL(url);
//     const hostname = parsed.hostname.toLowerCase();

//     if (hostname.includes("instagram.com")) return "instagram";
//     if (hostname.includes("youtube.com") || hostname.includes("youtu.be")) return "youtube";
//     if (hostname.includes("tiktok.com")) return "tiktok";
//     if (hostname.includes("twitter.com") || hostname.includes("x.com")) return "twitter";
//     if (hostname.includes("facebook.com")) return "facebook";

//     return "unknown";
//   } catch {
//     return "unknown";
//   }
// }
