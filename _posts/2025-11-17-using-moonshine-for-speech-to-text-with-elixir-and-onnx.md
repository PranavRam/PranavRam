---
layout: PrWebsite.PostLayout
title: "Using Moonshine for Speech-to-Text with Elixir and ONNX"
summary: "Learn how to integrate Moonshine, a real-time speech-to-text model, with Elixir using ONNX and Livebook for interactive audio transcription."
date: 2025-11-17
permalink: /posts/:title/
tags: ["elixir", "onnx", "speech-to-text", "livebook"]
---

This post will guide you through setting up and using the Moonshine library with Elixir and ONNX for building real-time speech-to-text applications. Moonshine is a powerful AI model that enables efficient speech transcription, and by integrating it with Elixir's ecosystem, you can create interactive demos using Livebook.

## Background

Moonshine is a machine learning model optimized for speech-to-text tasks. By leveraging ONNX (Open Neural Network Exchange), it provides a standardized way to run pre-trained models across different platforms. In this tutorial, we'll use Elixir's `ortex` library to interface with ONNX models and Livebook for an interactive, real-time transcription experience.

## Prerequisites

- **Elixir and Erlang**: Ensure you have Elixir and Erlang installed (version 1.19+ recommended).
- **Livebook**: An interactive environment for Elixir. Install it via `mix escript.install hex livebook`.
- **ONNX Runtime**: Required for running ONNX models. The `ortex` library handles this integration.
- **Audio Access**: For real-time demos, you'll need microphone access.

## Setup and Installation

We'll use `Mix.install` to set up the necessary dependencies directly in Livebook. This approach allows for easy experimentation without a full project setup.

```elixir
# Install all necessary dependencies for the Moonshine integration
Mix.install(
  [
    :nx,                    # Multi-dimensional arrays and numerical computing
    :bumblebee,             # Machine learning utilities for Elixir
    :kino_bumblebee,        # Kino integration for Bumblebee
    :exla,                  # Elixir bindings for XLA (Accelerated Linear Algebra)
    :ortex,                 # Elixir interface for ONNX Runtime
    :kino,                  # Interactive widgets for Livebook
    :jason,                 # JSON parsing library
    :kino_live_audio        # Audio capture widget for Livebook
  ],
  # Configure Nx to use EXLA backend for GPU acceleration if available
  config: [nx: [default_backend: EXLA.Backend]]
)
```

These dependencies include:
- `:nx` and `:exla` for numerical computations and acceleration.
- `:bumblebee` and `:kino_bumblebee` for machine learning utilities.
- `:ortex` for ONNX model loading and inference.
- `:kino` and `:kino_live_audio` for interactive Livebook widgets.

**Note**: This tutorial requires improvements made in [PR #3](https://github.com/acalejos/kino_live_audio/pull/3) for KinoLiveAudio, which added start/stop events and fixed restarting recording to enable reliable real-time speech processing.

## Loading Models and Tokenizers

The core of integrating Moonshine involves loading the ONNX model components and the tokenizer. You'll need to obtain the model files (`.onnx` files for preprocess, encode, uncached_decode, cached_decode) and a `tokenizer.json` file. You can download these assets from the [Moonshine GitHub repository](https://github.com/moonshine-ai/moonshine).

### Setting Up Assets Directory

First, define the path to your assets. For better configurability, use application environment variables instead of hardcoded paths:

```elixir
defmodule Moonshine.Model do
  # Retrieve assets directory from application config for flexibility
  @assets_dir Application.get_env(:moonshine, :assets_dir, "path-to-assets")

  # ... rest of the module functions will be defined below
end
```

You can set this in your `config/config.exs`:

```elixir
config :moonshine, assets_dir: "/path/to/your/assets"
```

### Loading the Tokenizer

The tokenizer converts text tokens to and from numerical representations. Add proper error handling:

```elixir
# Load the tokenizer from file with proper error handling
@spec load_tokenizer() :: {:ok, any()} | {:error, String.t()}
def load_tokenizer do
  # Construct the path to the tokenizer JSON file
  tokenizer_path = Path.join(@assets_dir, "tokenizer.json")

  # Attempt to load the tokenizer and handle both success and failure cases
  case Tokenizers.Tokenizer.from_file(tokenizer_path) do
    {:ok, tokenizer} ->
      {:ok, tokenizer}

    {:error, reason} ->
      # Log the error for debugging while providing a user-friendly message
      Logger.error("Failed to load tokenizer: #{inspect(reason)}")
      {:error, "Tokenizer loading failed"}
  end
end
```

### Loading the ONNX Model

Moonshine's model consists of multiple ONNX components that handle different stages of processing. Include error handling and logging:

```elixir
# Load all ONNX model components for the specified model with comprehensive error handling
@spec load_model(String.t()) :: {:ok, map()} | {:error, String.t()}
def load_model(model_name) do
  Logger.info("Loading Moonshine model: #{model_name}")

  # First, get the paths to all required ONNX files
  case get_onnx_weights(model_name) do
    {:ok, [preprocess_path, encode_path, uncached_decode_path, cached_decode_path]} ->
      # Use with/1 to load all components, short-circuiting on any failure
      with {:ok, preprocess} <- load_onnx_component(preprocess_path),
           {:ok, encode} <- load_onnx_component(encode_path),
           {:ok, uncached_decode} <- load_onnx_component(uncached_decode_path),
           {:ok, cached_decode} <- load_onnx_component(cached_decode_path) do
        # Package all loaded components into a model map
        model = %{
          preprocess: preprocess,
          encode: encode,
          uncached_decode: uncached_decode,
          cached_decode: cached_decode
        }

        Logger.info("Model loaded successfully")
        {:ok, model}
      else
        # Handle any component loading failure
        {:error, reason} ->
          Logger.error("Failed to load model component: #{reason}")
          {:error, reason}
      end

    # Handle case where ONNX files are not found
    {:error, reason} ->
      {:error, reason}
  end
end

# Generate paths for all required ONNX model files and verify they exist
@spec get_onnx_weights(String.t()) :: {:ok, [String.t()]} | {:error, String.t()}
def get_onnx_weights(_model_name) do
  # List of required ONNX components for Moonshine model
  onnx_files = ["preprocess", "encode", "uncached_decode", "cached_decode"]
  # Build full paths for each ONNX file
  paths = Enum.map(onnx_files, &Path.join(@assets_dir, "#{&1}.onnx"))

  # Verify all files exist before proceeding
  if Enum.all?(paths, &File.exists?/1) do
    {:ok, paths}
  else
    {:error, "One or more ONNX files not found in #{@assets_dir}"}
  end
end

# Load a single ONNX model component using Ortex
@spec load_onnx_component(String.t()) :: {:ok, any()} | {:error, String.t()}
defp load_onnx_component(path) do
  # Attempt to load the ONNX model from the specified path
  case Ortex.load(path) do
    {:ok, component} ->
      {:ok, component}

    {:error, reason} ->
      # Provide detailed error message including the file name
      {:error, "Failed to load #{Path.basename(path)}: #{inspect(reason)}"}
  end
end
```

This loads each ONNX model component using `Ortex.load/1` and returns them in a map for easy access during inference.

## Running the Speech-to-Text Demo

With the models loaded, we can create a real-time transcription demo using Livebook's interactive features. Make sure to add `:logger` to your dependencies if not already included. First, initialize the state manager and load the models:

```elixir
# Start the state manager
{:ok, _pid} = Moonshine.S2TState.start_link()

# Load and set the tokenizer
{:ok, tokenizer} = Moonshine.Model.load_tokenizer()
:ok = Moonshine.S2TState.set_tokenizer(tokenizer)

# Load and set the model
{:ok, model} = Moonshine.Model.load_model("base")
:ok = Moonshine.S2TState.set_model(model)
```

### State Management

For better robustness and control, we'll use a `GenServer` instead of an `Agent` to manage the model and tokenizer state. This allows for supervised startup and more complex state handling:

```elixir
defmodule Moonshine.S2TState do
  use GenServer

  # Start the GenServer with a registered name for easy access
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  # Initialize state with nil values for model and tokenizer
  def init(_opts) do
    {:ok, %{model: nil, tokenizer: nil}}
  end

  # API function to store the loaded model
  def set_model(model) do
    GenServer.call(__MODULE__, {:set_model, model})
  end

  # API function to store the loaded tokenizer
  def set_tokenizer(tokenizer) do
    GenServer.call(__MODULE__, {:set_tokenizer, tokenizer})
  end

  # API function to retrieve the current state
  def get_state do
    GenServer.call(__MODULE__, :get_state)
  end

  # Handle storing the model in state
  def handle_call({:set_model, model}, _from, state) do
    {:reply, :ok, Map.put(state, :model, model)}
  end

  # Handle storing the tokenizer in state
  def handle_call({:set_tokenizer, tokenizer}, _from, state) do
    {:reply, :ok, Map.put(state, :tokenizer, tokenizer)}
  end

  # Handle retrieving the entire state
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
end
```

### Speech-to-Text Module

This module handles the transcription process with proper error handling and typespecs:

```elixir
defmodule Moonshine.SpeechToText do
  # Main function to transcribe audio tensor to text
  @spec transcribe(Nx.Tensor.t()) :: {:ok, String.t()} | {:error, String.t()}
  def transcribe(audio) do
    # Retrieve current state from the GenServer
    case Moonshine.S2TState.get_state() do
      %{model: nil} ->
        {:error, "Model not loaded"}

      %{tokenizer: nil} ->
        {:error, "Tokenizer not loaded"}

      %{model: model, tokenizer: tokenizer} ->
        # Perform transcription with error handling
        try do
          # Call the core transcription logic (assumes SequenceParser is available)
          transcription = SequenceParser.generate_transcription(model, tokenizer, audio)
          {:ok, transcription}
        rescue
          e ->
            # Log any runtime errors during transcription
            Logger.error("Transcription failed: #{Exception.message(e)}")
            {:error, "Transcription processing failed"}
        end
    end
  end
end
```

The `SequenceParser.generate_transcription/3` function orchestrates the full pipeline:
1. **Preprocessing**: Prepares the audio data for the model.
2. **Encoding**: Processes the audio to create a context representation.
3. **Decoding**: Generates tokens sequentially, using cached decoding for efficiency after the initial step.
4. **Token-to-Text Conversion**: Uses the tokenizer to convert tokens back to readable text.

### Real-Time Audio Capture and Transcription

Using `KinoLiveAudio` and `Kino.Frame`, we can capture audio and display transcriptions in real-time. To prevent memory issues, we'll limit the audio buffer and use asynchronous processing with Tasks:

```elixir
# Set up audio capture with 500ms chunks at 16kHz sample rate (optimal for speech models)
live_audio = KinoLiveAudio.new(chunk_size: 500, unit: :ms, sample_rate: 16000)

# Create a Kino frame to display transcription results dynamically
live_transcription = Kino.Frame.new()

# Limit audio buffer to prevent memory growth (30 seconds of audio at 16kHz)
max_audio_length = 30 * 16000

# Set up streaming audio processing pipeline
live_audio
|> Kino.Control.stream()  # Convert to stream for processing
|> Kino.listen(  # Listen to audio events
  %{audio: []},  # Initial state with empty audio buffer
  fn
    %{event: :start_audio}, state ->
      Logger.info("Audio capture started")
      {:cont, state}  # Continue processing

    %{event: :stop_audio}, state ->
      Logger.info("Audio capture stopped")
      {:cont, state}  # Continue processing

    %{event: :audio_chunk, chunk: data}, state ->
      # Accumulate incoming audio data with buffer size limit to prevent memory issues
      new_audio = state.audio ++ data
      audio = if length(new_audio) > max_audio_length do
        # Keep only the most recent audio samples when buffer is full
        Enum.take(new_audio, -max_audio_length)
      else
        new_audio
      end

      # Convert accumulated audio to Nx tensor with proper shape for model input
      audio_tensor =
        Nx.tensor(audio, type: :f32)  # Float32 type for audio data
        |> Nx.reshape({1, :auto})     # Batch size 1, dynamic length

      # Process transcription asynchronously to avoid blocking the Livebook UI
      Task.async(fn ->
        case Moonshine.SpeechToText.transcribe(audio_tensor) do
          {:ok, transcription} ->
            # Update the display with the new transcription
            Kino.Frame.render(live_transcription, Kino.Text.new(transcription, chunk: true))

          {:error, reason} ->
            # Display error message if transcription fails
            Logger.error("Transcription error: #{reason}")
            Kino.Frame.render(live_transcription, Kino.Text.new("Error: #{reason}", chunk: true))
        end
      end)

      # Update state with the accumulated audio
      state = %{state | audio: audio}
      {:cont, state}  # Continue listening for more audio
  end
)
|> Kino.Layout.grid([live_transcription], boxed: true, gap: 16)
```

This setup captures audio chunks, accumulates them with a size limit, and processes transcriptions asynchronously to maintain real-time performance without blocking the Livebook interface.

## Key Considerations

- **Asset Paths**: Ensure all model files are correctly located and paths are absolute. Use environment configuration for flexibility.
- **Performance**: The cached decoding improves efficiency for ongoing transcription. Asynchronous processing prevents UI blocking.
- **Audio Quality**: Use a sample rate of 16000 Hz for optimal results with Moonshine. Limit audio buffer size to manage memory.
- **Error Handling**: Robust error handling with proper logging ensures graceful failures and easier debugging.
- **State Management**: Using GenServer provides better control and supervision compared to Agent.
- **Typespecs**: Adding @spec annotations improves code documentation and enables better tooling support.

## Conclusion

By integrating Moonshine with Elixir and ONNX, you've built a powerful speech-to-text system that leverages Elixir's concurrency and Livebook's interactivity. This setup enables real-time audio processing within the Elixir ecosystem, opening doors to applications like voice assistants, transcription services, and interactive AI demos.

Experiment with different audio inputs and explore extending the pipeline for additional features like language detection or speaker diarization. The combination of Elixir's robustness and ONNX's portability makes this a solid foundation for AI-powered applications.

For more advanced usage, check the Moonshine repository for model updates and additional configuration options.

*This tutorial is based on the implementation in [PR #92](https://github.com/moonshine-ai/moonshine/pull/92/files) of the Moonshine repository.*
