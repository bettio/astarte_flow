#
# This file is part of Astarte.
#
# Copyright 2019 Ispirata Srl
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

defmodule Astarte.Streams.Message do
  defstruct [
    :key,
    :metadata,
    :type,
    :subtype,
    :timestamp,
    :data
  ]

  @message_schema_version "astarte_streams/message/v0.1"

  @type message_basic_data ::
          number()
          | boolean()
          | DateTime.t()
          | binary()
          | String.t()
  @type message_data ::
          message_basic_data()
          | %{optional(String.t()) => message_basic_data()}
          | [message_basic_data()]

  @type message_metadata :: %{optional(String.t()) => String.t()}

  @type message_basic_type_atom :: :integer | :real | :boolean | :datetime | :binary | :string
  @type message_type_atom :: :map | {:array, message_basic_type_atom()}

  @type message_timestamp :: integer()

  @typedoc """
  An Astarte Streams message.

  * `:key`: a unicode string that identifies the stream the message belongs to.
  * `:metadata`: additional message metadata.
  * `:type': message data type (e.g. integer, real, boolean, etc...).
  * `:subtype`: a string that represents the subtype, that is a mimetype for binaries.
  * `:timestamp`: timestamp in microseconds.
  * `:data`: the message payload.
  """
  @type t :: %Astarte.Streams.Message{
          key: String.t(),
          metadata: message_metadata(),
          type: message_type_atom(),
          subtype: String.t(),
          timestamp: non_neg_integer(),
          data: message_data()
        }

  def to_map(%Astarte.Streams.Message{} = message) do
    %Astarte.Streams.Message{
      key: key,
      metadata: metadata,
      type: type,
      subtype: subtype,
      timestamp: timestamp,
      data: data
    } = message

    %{
      "schema" => @message_schema_version,
      "key" => key,
      "metadata" => metadata,
      "type" => type,
      "subtype" => subtype,
      "timestamp" => timestamp,
      "data" => data
    }
  end

  def from_map(%{"schema" => @message_schema_version} = map) do
    %{
      "key" => key,
      "metadata" => metadata,
      "type" => type,
      "subtype" => subtype,
      "timestamp" => timestamp,
      "data" => data
    } = map

    %Astarte.Streams.Message{
      key: key,
      metadata: metadata,
      type: type,
      subtype: subtype,
      timestamp: timestamp,
      data: data
    }
  end
end
