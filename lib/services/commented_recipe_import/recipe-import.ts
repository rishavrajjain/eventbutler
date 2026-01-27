// import OpenAI from "openai";
// import { Recipe, IngredientCategory } from "./types";
// import { ProxyAgent, fetch as undiciFetch } from "undici";
// import { getVideoTranscript, getVideoMetadata, isSupportedPlatform, detectPlatform } from "./transcription-service";
// import { getCachedRecipe, cacheRecipe, detectPlatformFromUrl, type ImportedRecipeData } from "./recipe-cache";
// import {
//   getPromptConfig,
//   buildContentSection,
//   buildPromptFromTemplate,
//   DEFAULT_PROMPT_CONFIG,
// } from "./prompt-config";

// // Lazy initialization to avoid build-time errors
// let openai: OpenAI | null = null;

// function getOpenAI(): OpenAI {
//   if (!openai) {
//     if (!process.env.OPENAI_API_KEY) {
//       throw new Error("OPENAI_API_KEY environment variable is not set");
//     }
//     openai = new OpenAI({
//       apiKey: process.env.OPENAI_API_KEY,
//     });
//   }
//   return openai;
// }

// // Multiple mobile user agents for rotation
// const USER_AGENTS = [
//   "Mozilla/5.0 (iPhone; CPU iPhone OS 17_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.2 Mobile/15E148 Safari/604.1",
//   "Mozilla/5.0 (iPhone; CPU iPhone OS 16_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1",
//   "Mozilla/5.0 (Linux; Android 14; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36",
//   "Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Mobile Safari/537.36",
// ];

// // Get proxy URL if configured (returns undefined if empty or not set)
// function getProxyUrl(): string | undefined {
//   const proxyUrl = process.env.PROXY_URL?.trim() || process.env.PROXY_URLS?.split(",")[0]?.trim();
//   // Only return if it's a valid non-empty URL
//   if (proxyUrl && proxyUrl.length > 0 && proxyUrl.startsWith("http")) {
//     console.log("Proxy URL configured for Instagram fetch");
//     return proxyUrl;
//   }
//   return undefined;
// }

// // Fetch with proxy support using undici (falls back to direct fetch if no proxy)
// async function fetchWithProxy(url: string, options: RequestInit = {}): Promise<Response> {
//   const proxyUrl = getProxyUrl();

//   if (proxyUrl) {
//     console.log(`Fetching via proxy: ${url}`);
//     try {
//       const proxyAgent = new ProxyAgent(proxyUrl);
//       const response = await undiciFetch(url, {
//         ...options,
//         dispatcher: proxyAgent,
//       } as Parameters<typeof undiciFetch>[1]);
//       return response as unknown as Response;
//     } catch (proxyError) {
//       console.log(`Proxy fetch failed: ${proxyError}, falling back to direct fetch`);
//       // Fall back to direct fetch if proxy fails
//       return fetch(url, options);
//     }
//   } else {
//     console.log(`Fetching directly (no proxy configured): ${url}`);
//     return fetch(url, options);
//   }
// }

// interface ExtractedMetadata {
//   caption: string;
//   thumbnailUrl: string;
//   creatorHandle: string;
//   creatorName: string;
// }

// /**
//  * Validates if URL is an Instagram URL
//  */
// export function isInstagramUrl(url: string): boolean {
//   try {
//     const parsed = new URL(url);
//     return (
//       parsed.hostname === "instagram.com" ||
//       parsed.hostname === "www.instagram.com" ||
//       parsed.hostname.endsWith(".instagram.com")
//     );
//   } catch {
//     return false;
//   }
// }

// /**
//  * Validates if URL is a YouTube URL
//  */
// export function isYouTubeUrl(url: string): boolean {
//   try {
//     const parsed = new URL(url);
//     return (
//       parsed.hostname === "youtube.com" ||
//       parsed.hostname === "www.youtube.com" ||
//       parsed.hostname === "youtu.be" ||
//       parsed.hostname === "m.youtube.com"
//     );
//   } catch {
//     return false;
//   }
// }

// /**
//  * Validates if URL is a supported video platform
//  */
// export function isSupportedVideoUrl(url: string): boolean {
//   return isInstagramUrl(url) || isYouTubeUrl(url) || isSupportedPlatform(url);
// }

// /**
//  * Fetches Instagram page and extracts metadata with proxy support and multiple strategies
//  */
// async function fetchInstagramMetadata(url: string): Promise<ExtractedMetadata> {
//   const userAgent = USER_AGENTS[Math.floor(Math.random() * USER_AGENTS.length)];

//   const headers: Record<string, string> = {
//     "User-Agent": userAgent,
//     "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8",
//     "Accept-Language": "en-US,en;q=0.9",
//     "Accept-Encoding": "gzip, deflate, br",
//     "Cache-Control": "no-cache",
//     "Pragma": "no-cache",
//     "Sec-CH-UA": '"Not_A Brand";v="8", "Chromium";v="122"',
//     "Sec-CH-UA-Mobile": "?1",
//     "Sec-CH-UA-Platform": '"iOS"',
//     "Sec-Fetch-Dest": "document",
//     "Sec-Fetch-Mode": "navigate",
//     "Sec-Fetch-Site": "none",
//     "Sec-Fetch-User": "?1",
//     "Upgrade-Insecure-Requests": "1",
//     "DNT": "1",
//     "Connection": "keep-alive",
//   };

//   console.log(`Fetching Instagram URL: ${url}`);

//   const response = await fetchWithProxy(url, {
//     headers,
//     redirect: "follow",
//   });

//   console.log(`Instagram response status: ${response.status}`);

//   if (!response.ok) {
//     throw new Error(`Failed to fetch Instagram page: ${response.status}`);
//   }

//   const html = await response.text();
//   console.log(`Instagram HTML length: ${html.length} chars`);

//   // Multiple extraction patterns for better success rate
//   let caption = "";
//   let thumbnailUrl = "";
//   let creatorHandle = "";
//   let creatorName = "";

//   // Caption extraction patterns (try multiple)
//   const captionPatterns = [
//     /<meta[^>]+property=["']og:description["'][^>]+content=["']([^"']+)["']/i,
//     /<meta[^>]+name=["']description["'][^>]+content=["']([^"']+)["']/i,
//     /"caption"\s*:\s*\{\s*"text"\s*:\s*"([^"]+)"/,
//     /"edge_media_to_caption".*?"text"\s*:\s*"([^"]+)"/,
//     /"description"\s*:\s*"([^"]+)"/,
//   ];

//   for (const pattern of captionPatterns) {
//     const match = html.match(pattern);
//     if (match && match[1] && match[1].length > caption.length) {
//       caption = decodeHtmlEntities(match[1]);
//       console.log(`Found caption via pattern: ${caption.substring(0, 100)}...`);
//     }
//   }

//   // Thumbnail extraction patterns
//   const thumbnailPatterns = [
//     /<meta[^>]+property=["']og:image["'][^>]+content=["']([^"']+)["']/i,
//     /<meta[^>]+name=["']twitter:image["'][^>]+content=["']([^"']+)["']/i,
//     /"thumbnail_src"\s*:\s*"([^"]+)"/,
//     /"display_url"\s*:\s*"([^"]+)"/,
//   ];

//   for (const pattern of thumbnailPatterns) {
//     const match = html.match(pattern);
//     if (match && match[1]) {
//       thumbnailUrl = decodeHtmlEntities(match[1].replace(/\\u0026/g, "&"));
//       console.log(`Found thumbnail: ${thumbnailUrl.substring(0, 80)}...`);
//       break;
//     }
//   }

//   // Username extraction patterns (ordered by reliability)
//   const usernamePatterns = [
//     // Extract from og:url (e.g., instagram.com/eitan/reel/...)
//     /og:url"[^>]*content="https?:\/\/(?:www\.)?instagram\.com\/([A-Za-z0-9._]+)\/(?:reel|p)\//i,
//     // Extract from twitter:title (e.g., "Eitan (@eitan)")
//     /twitter:title"[^>]*content="[^"]*\((?:@|&#064;)([A-Za-z0-9._]+)\)/i,
//     // JSON patterns
//     /"username"\s*:\s*"([A-Za-z0-9._]+)"/,
//     /"owner"\s*:\s*\{[^}]*"username"\s*:\s*"([A-Za-z0-9._]+)"/,
//     // URL pattern (less reliable - might match post paths)
//     /instagram\.com\/([A-Za-z0-9._]+)\//,
//     // @ mention pattern (least reliable)
//     /@([A-Za-z0-9._]+)/,
//   ];

//   for (const pattern of usernamePatterns) {
//     const match = html.match(pattern);
//     if (match && match[1] && !["p", "reel", "reels", "stories"].includes(match[1].toLowerCase())) {
//       creatorHandle = `@${match[1]}`;
//       console.log(`Found creator handle: ${creatorHandle}`);
//       break;
//     }
//   }

//   // Full name extraction
//   const namePatterns = [
//     /"full_name"\s*:\s*"([^"]+)"/,
//     /"name"\s*:\s*"([^"]+)"/,
//   ];

//   for (const pattern of namePatterns) {
//     const match = html.match(pattern);
//     if (match && match[1]) {
//       creatorName = decodeHtmlEntities(match[1]);
//       break;
//     }
//   }

//   // Also try to extract from JSON-LD
//   const jsonLdMatch = html.match(/<script[^>]+type=["']application\/ld\+json["'][^>]*>([\s\S]*?)<\/script>/i);
//   if (jsonLdMatch) {
//     try {
//       const jsonLd = JSON.parse(jsonLdMatch[1]);
//       if (jsonLd.description && !caption) {
//         caption = jsonLd.description;
//       }
//       if (jsonLd.thumbnailUrl && !thumbnailUrl) {
//         thumbnailUrl = jsonLd.thumbnailUrl;
//       }
//       if (jsonLd.author?.name && !creatorName) {
//         creatorName = jsonLd.author.name;
//       }
//     } catch (e) {
//       // JSON-LD parsing failed, continue with regex results
//     }
//   }

//   console.log(`Extraction results - Caption: ${caption.length} chars, Thumbnail: ${!!thumbnailUrl}, Handle: ${creatorHandle}`);

//   return {
//     caption,
//     thumbnailUrl,
//     creatorHandle,
//     creatorName,
//   };
// }

// /**
//  * Try Instagram oEmbed API as fallback (with proxy support)
//  */
// async function tryOembedFallback(
//   url: string
// ): Promise<Partial<ExtractedMetadata>> {
//   try {
//     const oembedUrl = `https://www.instagram.com/oembed/?url=${encodeURIComponent(url)}&omitscript=true`;

//     const response = await fetchWithProxy(oembedUrl, {
//       headers: {
//         "User-Agent": USER_AGENTS[0],
//         "Accept": "application/json",
//       },
//     });

//     if (!response.ok) {
//       console.log(`oEmbed failed with status: ${response.status}`);
//       return {};
//     }

//     const data = await response.json();
//     console.log(`oEmbed success - title: ${data.title?.substring(0, 50)}`);

//     return {
//       caption: data.title || "",
//       thumbnailUrl: data.thumbnail_url || "",
//       creatorName: data.author_name || "",
//     };
//   } catch (error) {
//     console.log(`oEmbed error: ${error}`);
//     return {};
//   }
// }

// /**
//  * Decode HTML entities
//  */
// function decodeHtmlEntities(text: string): string {
//   return text
//     .replace(/&amp;/g, "&")
//     .replace(/&lt;/g, "<")
//     .replace(/&gt;/g, ">")
//     .replace(/&quot;/g, '"')
//     .replace(/&#39;/g, "'")
//     .replace(/&#x27;/g, "'")
//     .replace(/&#x2F;/g, "/")
//     .replace(/\\u0026/g, "&")
//     .replace(/\\u003c/g, "<")
//     .replace(/\\u003e/g, ">")
//     .replace(/\\n/g, "\n");
// }

// /**
//  * Use GPT-5-mini to extract recipe from combined transcript + caption
//  * Enhanced to handle dual-source input for better extraction
//  * Now uses dynamic prompt configuration from Firestore
//  */
// async function extractRecipeWithGPT(
//   transcript: string | null,
//   caption: string,
//   thumbnailUrl: string,
//   creatorHandle: string,
//   creatorName: string,
//   originalUrl: string
// ): Promise<{
//   recipe: Omit<Recipe, "id" | "slug" | "favoriteCount" | "commentCount" | "authorId" | "createdAt">;
//   promptVersion: number;
// }> {
//   // Fetch dynamic prompt configuration (with caching)
//   let promptConfig;
//   try {
//     promptConfig = await getPromptConfig();
//     console.log(`[GPT] Using prompt version ${promptConfig.version}`);
//   } catch (error) {
//     console.log("[GPT] Failed to fetch prompt config, using defaults:", error);
//     promptConfig = {
//       userPrompt: DEFAULT_PROMPT_CONFIG.userPrompt,
//       systemMessage: DEFAULT_PROMPT_CONFIG.systemMessage,
//       version: 0,
//       updatedAt: new Date(),
//       updatedBy: "fallback",
//     };
//   }

//   // Build content section based on available sources
//   const contentSection = buildContentSection(transcript, caption);

//   // Build the final prompt from template
//   const prompt = buildPromptFromTemplate(
//     promptConfig.userPrompt,
//     contentSection,
//     thumbnailUrl
//   );

//   console.log("Sending caption to GPT for extraction...");

//   const response = await getOpenAI().chat.completions.create({
//     model: "gpt-5-mini",
//     messages: [
//       {
//         role: "system",
//         content: promptConfig.systemMessage,
//       },
//       { role: "user", content: prompt },
//     ],
//     response_format: { type: "json_object" },
//   });

//   const content = response.choices[0]?.message?.content;
//   if (!content) {
//     throw new Error("No response from GPT");
//   }

//   console.log("GPT response received, parsing...");
//   const parsed = JSON.parse(content);

//   // Validate that this is actually a food recipe
//   if (parsed.isValidFoodRecipe === false) {
//     const reason = parsed.notFoodReason || "This doesn't appear to be a food recipe. Please share a cooking video.";
//     console.log(`[Import] Content validation failed: ${reason}`);
//     throw new Error(reason);
//   }

//   // Fallback validation: ensure we have minimum recipe structure
//   if (!parsed.ingredients || parsed.ingredients.length < 2) {
//     throw new Error("Could not identify enough ingredients. Is this a food recipe?");
//   }

//   if (!parsed.steps || parsed.steps.length < 1) {
//     throw new Error("Could not identify cooking steps. Is this a food recipe?");
//   }

//   // Ensure ingredients have proper structure
//   const ingredients = (parsed.ingredients || []).map((ing: Record<string, unknown>, idx: number) => ({
//     id: ing.id || `ing${idx + 1}`,
//     name: ing.name || "Unknown ingredient",
//     quantity: typeof ing.quantity === "number" ? ing.quantity : 1,
//     unit: ing.unit || "piece",
//     category: ing.category || IngredientCategory.OTHER,
//     notes: ing.notes || undefined,
//   }));

//   // Ensure steps have proper structure
//   const steps = (parsed.steps || []).map((step: Record<string, unknown>, idx: number) => ({
//     id: step.id || `s${idx + 1}`,
//     stepNumber: step.stepNumber || idx + 1,
//     instruction: step.instruction || String(step),
//   }));

//   return {
//     recipe: {
//       title: parsed.title || "Imported Recipe",
//       description: parsed.description || "",
//       image: parsed.image || thumbnailUrl,
//       prepTime: Math.max(1, parseInt(parsed.prepTime) || 10),
//       cookTime: Math.max(1, parseInt(parsed.cookTime) || 20),
//       totalTime: Math.max(1, parseInt(parsed.totalTime) || (parseInt(parsed.prepTime) || 10) + (parseInt(parsed.cookTime) || 20)),
//       servings: Math.max(1, parseInt(parsed.servings) || 2),
//       nutrition: {
//         calories: parseInt(parsed.nutrition?.calories) || 0,
//         protein: parseInt(parsed.nutrition?.protein) || 0,
//         carbs: parseInt(parsed.nutrition?.carbs) || 0,
//         fat: parseInt(parsed.nutrition?.fat) || 0,
//       },
//       ingredients,
//       steps,
//       categories: parsed.categories || [],
//       tags: parsed.tags || [],
//     },
//     promptVersion: promptConfig.version,
//   };
// }

// /**
//  * Main function to import recipe from Instagram URL
//  * Uses Supadata as primary source for all metadata (caption, thumbnail, creator).
//  * HTML scraping is disabled by default to avoid IP bans from Instagram.
//  * Set ENABLE_HTML_SCRAPING_FALLBACK=true to enable HTML scraping as fallback.
//  */
// export async function importRecipeFromInstagram(url: string): Promise<{
//   success: boolean;
//   recipe?: Omit<Recipe, "id" | "slug" | "favoriteCount" | "commentCount" | "authorId" | "createdAt"> & {
//     creatorHandle?: string;
//     creatorName?: string;
//     originalUrl?: string;
//   };
//   error?: string;
//   promptVersion?: number;
// }> {
//   try {
//     // Validate URL
//     if (!isInstagramUrl(url)) {
//       return { success: false, error: "Invalid Instagram URL" };
//     }

//     console.log(`[Import] Starting Supadata-first extraction for: ${url}`);

//     // Step 1: Fetch transcript and Supadata metadata in parallel
//     console.log("[Import] Step 1: Fetching audio transcript and Supadata metadata...");
//     const [transcriptResult, supadataMetadata] = await Promise.all([
//       getVideoTranscript(url),
//       getVideoMetadata(url),
//     ]);

//     if (transcriptResult.transcript) {
//       console.log(`[Import] Transcript received: ${transcriptResult.transcript.length} chars`);
//     } else {
//       console.log(`[Import] No transcript available: ${transcriptResult.error || "unknown"}`);
//     }

//     // Step 2: Extract ALL metadata from Supadata (primary source)
//     let caption = supadataMetadata?.description || supadataMetadata?.title || "";
//     // Check both root-level and nested media.thumbnailUrl (API returns different structures)
//     let thumbnailUrl = supadataMetadata?.thumbnailUrl || supadataMetadata?.media?.thumbnailUrl || "";
//     let creatorHandle = supadataMetadata?.author?.username ? `@${supadataMetadata.author.username}` : "";
//     let creatorName = supadataMetadata?.author?.displayName || "";

//     console.log(`[Import] Supadata metadata - Caption: ${caption.length} chars, Thumbnail: ${!!thumbnailUrl}, Creator: ${creatorHandle}`);

//     // Step 2.5: Try oEmbed API if thumbnail is missing (lightweight fallback, always enabled)
//     if (!thumbnailUrl) {
//       console.log("[Import] Thumbnail missing from Supadata, trying oEmbed API...");
//       try {
//         const oembedData = await tryOembedFallback(url);
//         if (oembedData.thumbnailUrl) {
//           thumbnailUrl = oembedData.thumbnailUrl;
//           console.log(`[Import] oEmbed provided thumbnail: ${thumbnailUrl.substring(0, 80)}...`);
//         }
//         // Also fill in other missing data from oEmbed if available
//         if (!caption && oembedData.caption) {
//           caption = oembedData.caption;
//         }
//         if (!creatorName && oembedData.creatorName) {
//           creatorName = oembedData.creatorName;
//         }
//       } catch (oembedError) {
//         console.log(`[Import] oEmbed fallback failed: ${oembedError}`);
//       }
//     }

//     // Step 3: ONLY use HTML scraping as fallback if explicitly enabled AND Supadata incomplete
//     const enableHtmlFallback = process.env.ENABLE_HTML_SCRAPING_FALLBACK === "true";
//     const needsFallback = !caption || !thumbnailUrl;

//     if (enableHtmlFallback && needsFallback) {
//       console.log("[Import] Step 3: Supadata incomplete, using HTML fallback (explicitly enabled)...");
//       try {
//         const htmlMetadata = await fetchInstagramMetadata(url);
//         caption = caption || htmlMetadata.caption;
//         thumbnailUrl = thumbnailUrl || htmlMetadata.thumbnailUrl;
//         creatorHandle = creatorHandle || htmlMetadata.creatorHandle;
//         creatorName = creatorName || htmlMetadata.creatorName;
//         console.log(`[Import] HTML fallback - Caption: ${htmlMetadata.caption.length} chars, Thumbnail: ${!!htmlMetadata.thumbnailUrl}`);
//       } catch (htmlError) {
//         console.log(`[Import] HTML fallback failed: ${htmlError}`);
//         // Try oEmbed as last resort
//         try {
//           const oembedData = await tryOembedFallback(url);
//           caption = caption || oembedData.caption || "";
//           thumbnailUrl = thumbnailUrl || oembedData.thumbnailUrl || "";
//           creatorName = creatorName || oembedData.creatorName || "";
//         } catch (oembedError) {
//           console.log(`[Import] oEmbed fallback also failed: ${oembedError}`);
//         }
//       }
//     } else if (needsFallback) {
//       console.log("[Import] Step 3: Supadata incomplete, but HTML fallback disabled (set ENABLE_HTML_SCRAPING_FALLBACK=true to enable)");
//     } else {
//       console.log("[Import] Step 3: Supadata metadata complete, skipping HTML scraping");
//     }

//     // Check if we have enough content from available sources
//     const hasTranscript = !!transcriptResult.transcript;
//     const hasCaption = !!caption;
//     const hasThumbnail = !!thumbnailUrl;

//     console.log(`[Import] Final sources - Transcript: ${hasTranscript}, Caption: ${hasCaption}, Thumbnail: ${hasThumbnail}`);

//     if (!hasTranscript && !hasCaption) {
//       return {
//         success: false,
//         error: "Could not extract content from Instagram post. Neither audio transcript nor caption available.",
//       };
//     }

//     // Step 4: Extract recipe using GPT with combined sources
//     console.log("[Import] Step 4: Extracting recipe with GPT...");
//     const { recipe, promptVersion } = await extractRecipeWithGPT(
//       transcriptResult.transcript,
//       caption,
//       thumbnailUrl,
//       creatorHandle,
//       creatorName,
//       url
//     );

//     console.log(`[Import] Recipe extracted successfully: ${recipe.title}`);

//     return {
//       success: true,
//       recipe: {
//         ...recipe,
//         creatorHandle,
//         creatorName,
//         originalUrl: url,
//       },
//       promptVersion,
//     };
//   } catch (error) {
//     console.error("Recipe import error:", error);
//     return {
//       success: false,
//       error: error instanceof Error ? error.message : "Failed to import recipe",
//     };
//   }
// }

// /**
//  * Import recipe from YouTube URL
//  * Uses audio transcript as primary source
//  */
// export async function importRecipeFromYouTube(url: string): Promise<{
//   success: boolean;
//   recipe?: Omit<Recipe, "id" | "slug" | "favoriteCount" | "commentCount" | "authorId" | "createdAt"> & {
//     creatorHandle?: string;
//     creatorName?: string;
//     originalUrl?: string;
//   };
//   error?: string;
//   promptVersion?: number;
// }> {
//   try {
//     // Validate URL
//     if (!isYouTubeUrl(url)) {
//       return { success: false, error: "Invalid YouTube URL" };
//     }

//     console.log(`[Import] Starting YouTube extraction for: ${url}`);

//     // Get audio transcript via Supadata
//     console.log("[Import] Fetching audio transcript from YouTube...");
//     const transcriptResult = await getVideoTranscript(url);

//     if (!transcriptResult.transcript) {
//       return {
//         success: false,
//         error: `Could not get transcript from YouTube: ${transcriptResult.error || "Unknown error"}`,
//       };
//     }

//     console.log(`[Import] Transcript received: ${transcriptResult.transcript.length} chars`);

//     // Extract recipe using GPT
//     console.log("[Import] Extracting recipe with GPT...");
//     const { recipe, promptVersion } = await extractRecipeWithGPT(
//       transcriptResult.transcript,
//       "", // No caption for YouTube
//       "", // No thumbnail (could fetch via YouTube API later)
//       "", // No handle
//       "", // No name
//       url
//     );

//     console.log(`[Import] Recipe extracted successfully: ${recipe.title}`);

//     return {
//       success: true,
//       recipe: {
//         ...recipe,
//         originalUrl: url,
//       },
//       promptVersion,
//     };
//   } catch (error) {
//     console.error("YouTube recipe import error:", error);
//     return {
//       success: false,
//       error: error instanceof Error ? error.message : "Failed to import recipe from YouTube",
//     };
//   }
// }

// /**
//  * Universal recipe import function - detects platform and routes appropriately
//  * Checks cache first to avoid reprocessing previously imported recipes.
//  */
// export async function importRecipeFromUrl(url: string): Promise<{
//   success: boolean;
//   recipe?: Omit<Recipe, "id" | "slug" | "favoriteCount" | "commentCount" | "authorId" | "createdAt"> & {
//     creatorHandle?: string;
//     creatorName?: string;
//     originalUrl?: string;
//   };
//   error?: string;
//   platform?: string;
//   fromCache?: boolean;
//   promptVersion?: number;
// }> {
//   const platform = detectPlatform(url);
//   console.log(`[Import] Detected platform: ${platform}`);

//   // Check cache first
//   try {
//     const cached = await getCachedRecipe(url);
//     if (cached) {
//       console.log(`[Import] Returning cached recipe: ${cached.recipe.title}`);
//       return {
//         success: true,
//         recipe: cached.recipe,
//         platform: cached.platform,
//         fromCache: true,
//       };
//     }
//   } catch (cacheError) {
//     console.log(`[Import] Cache lookup failed, proceeding with fresh import: ${cacheError}`);
//   }

//   // Process fresh import
//   let result: {
//     success: boolean;
//     recipe?: ImportedRecipeData;
//     error?: string;
//     promptVersion?: number;
//   };

//   if (platform === "instagram") {
//     result = await importRecipeFromInstagram(url);
//   } else if (platform === "youtube") {
//     result = await importRecipeFromYouTube(url);
//   } else if (isSupportedPlatform(url)) {
//     // For other platforms, try generic transcript-based extraction
//     console.log(`[Import] Attempting generic transcript extraction for: ${platform}`);
//     const transcriptResult = await getVideoTranscript(url);

//     if (!transcriptResult.transcript) {
//       return {
//         success: false,
//         error: `Could not get transcript from ${platform}: ${transcriptResult.error || "Unknown error"}`,
//         platform,
//         fromCache: false,
//       };
//     }

//     try {
//       const { recipe, promptVersion } = await extractRecipeWithGPT(
//         transcriptResult.transcript,
//         "",
//         "",
//         "",
//         "",
//         url
//       );
//       result = { success: true, recipe: { ...recipe, originalUrl: url }, promptVersion };
//     } catch (error) {
//       result = {
//         success: false,
//         error: error instanceof Error ? error.message : "Failed to extract recipe",
//       };
//     }
//   } else {
//     return {
//       success: false,
//       error: "Unsupported platform. Currently supports Instagram, YouTube, and TikTok.",
//       platform: "unknown",
//       fromCache: false,
//     };
//   }

//   // Cache successful imports
//   if (result.success && result.recipe) {
//     try {
//       const cachePlatform = detectPlatformFromUrl(url);
//       await cacheRecipe(url, result.recipe, cachePlatform);
//     } catch (cacheError) {
//       console.log(`[Import] Failed to cache recipe: ${cacheError}`);
//       // Don't fail the import if caching fails
//     }
//   }

//   return {
//     ...result,
//     platform,
//     fromCache: false,
//     promptVersion: result.promptVersion,
//   };
// }
